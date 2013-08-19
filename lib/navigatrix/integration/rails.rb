require "navigatrix/view_helpers"

module Navigatrix
  class Railtie < ::Rails::Railtie
    initializer "navigatrix.view_helpers" do
      ActionView::Base.send :include, Navigatrix::ViewHelpers
    end
  end
end