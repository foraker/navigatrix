require "action_view"

module Navigatrix
  module Rendering
    module Strategies
      module ContentHelpers
        include ActionView::Helpers::TagHelper
        include ActionView::Helpers::UrlHelper

        def capture
          yield
        end
      end
    end
  end
end
