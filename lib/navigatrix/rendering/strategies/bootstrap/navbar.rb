require "navigatrix/rendering/strategies/list"

module Navigatrix::Rendering::Strategies
  module Bootstrap
    class Navbar < List

      private

      def html_attributes
        super.merge_attribute(:class, "nav")
      end

      def items
        super.map { |item| (item.has_children? ? Item : List::Item).new(item, options) }
      end

      class Item < List::Item
        private

        def html_attributes
          super.merge_attribute(:class, "dropdown")
        end

        def name
          (super + dropdown_icon).html_safe
        end

        def nested_list
          List.new(children, options).render if has_children?
        end

        def dropdown_icon
          options[:dropdown_icon] || content_tag(:i, nil, :class => "icon-chevron-down icon-white")
        end
      end
    end
  end
end
