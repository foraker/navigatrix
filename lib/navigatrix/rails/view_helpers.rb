module Navigatrix
  module Rails
    module ViewHelpers
      def render_navigation(configuration, options = {})
        Navigatrix::Renderer.new(configuration, options.merge({:render_context => self})).render
      end
    end
  end
end