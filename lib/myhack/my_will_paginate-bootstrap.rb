require "will_paginate/view_helpers/action_view"
require "myhack/my_bootstrap_renderer"

module MyBootstrapPagination
  # A custom renderer class for WillPaginate that produces markup suitable for use with Twitter Bootstrap.
  class Rails < WillPaginate::ActionView::LinkRenderer
    include MyBootstrapPagination::BootstrapRenderer
  end
end