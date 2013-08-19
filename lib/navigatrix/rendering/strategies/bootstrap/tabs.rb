module Navigatrix::Rendering::Strategies
  module Bootstrap
    class Tabs < List

      private

      def html_attributes
        super.merge_attribute(:class, "nav nav-tabs")
      end
    end
  end
end
