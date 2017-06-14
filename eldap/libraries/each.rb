# The method "eldap_execute" works like 'each'.
# For instance, in the recipe, you would use:
#
# eldap_execute "search_username" do |result|
#   ...(your code block)...
# end
#

# This uses blocks. Why does it use blocks? Although it seems like
# a resource, it's called like a ruby function. Different from a resources that
# don't be executed as soon as Chef load them. Chef load them all first to
# create links between then (notify, actions, conditions, etc...)

# So the blocks in this case are stored and then they are executed when
# eldap (action :search) is called. So them we guaranty that the block will be
# executed in the right time, when the eldap (action :search) has effectively
# the results.

class Chef
  class Recipe
    # A shortcut to a customer
    def eldap_execute(name, &block)
      Eldap::Search.add_block name do
        results = Eldap::Search.get_result_from(name)
        results.each do |result|
          block.call(result)
        end
      end
    end
  end
end
