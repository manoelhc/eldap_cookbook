require 'chef/resource'
require 'rubygems'
require 'net/ldap'

# This is the main class library. It's used basically to handle the LDAP search.
#
# As resouces are something trick to deal with, this class will be something
# not too familiar for you (or not).
#
# Basically, Eldap::Search is a class with static methods.
#   * add_block: store blocks of eldap (action :search) resource to be
#                executed in the correct timing. See each.rb

#   * get_result_from: get the result of a search by the search name

#   * run_block: run stored blocks by search name

#   * set_connection: set connection. It supports multiple connections

#   * self.search: perform queries by filter, basedn and connction name. You
#                  can speficy which fields you want to return.


module Eldap
  class Search < Chef::Resource
    @@blocks = {}
    @@results = {}
    @@conf = {}
    @@node = {}
    LDAP_DEFAULT_CONFIG = {
      :host         => 'localhost',
      :port         => '389',
      :auth         => {
          :method     => 'simple',
          :username   => 'ldap_user',
          :password   => 'ldap_pass'
      }
    }
    def self.add_block(name, &block)
      if @@blocks[name].nil?
        @@blocks[name] = block
      else
      end
    end
    def self.get_result_from(key)
      @@results[key] || []
    end
    def self.run_block(name)
      unless @@blocks[name].nil?
        @@blocks[name].call
        @@blocks[name] = nil
      end
    end

    def self.set_connection(info, name)
      @@conf[name] = LDAP_DEFAULT_CONFIG.merge(info)
      @@conf[name][:auth][:method] = @@conf[name][:auth][:method].to_sym
    end

    def self.search(conn_name, search_name, basedn, filters, search)

      ldap_filters = nil

      filters.each do |farr|
        key        = farr[0]
        comparison = farr[1]
        value      = farr[2]

        filter = Net::LDAP::Filter.eq(key, value)    if comparison == :eq
        filter = Net::LDAP::Filter.ge(key, value)    if comparison == :ge
        filter = Net::LDAP::Filter.gt(key, value)    if comparison == :gt
        filter = Net::LDAP::Filter.le(key, value)    if comparison == :le
        filter = Net::LDAP::Filter.lt(key, value)    if comparison == :lt
        filter = Net::LDAP::Filter.pres(key)         if comparison == :asterisk

        if ldap_filters.nil?
          ldap_filters = filter
        else
          ldap_filters = Net::LDAP::Filter.join(ldap_filters, filter)
        end
      end

      results = []

      Net::LDAP.open(@@conf[conn_name]) do |ldap|
        ldap.search(:base => basedn, :filter => ldap_filters) do |item|
          process = {}
          search.each do |property|
            prop = property.to_sym
            unless item[prop].nil? && process.nil?
              val = item[prop]
              if val.length == 1
                process[property] = val.first
              else
                process[property] = val
              end
            else
              process = nil
            end
          end
          results.push(process) unless process.nil?
        end
      end
      @@results[search_name] = results
      self.run_block search_name
    end
  end
end
