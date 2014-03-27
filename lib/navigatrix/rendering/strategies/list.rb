require "action_view"
require "delegate"

module Navigatrix
  module Rendering
    module Strategies
      class List < Struct.new(:items, :options)
        include ActionView::Helpers::TagHelper
        include ActionView::Helpers::UrlHelper

        def render
          content_tag(:ul, render_items, html_attributes)
        end

        def render_items
          items.map(&:render).join.html_safe
        end

        private

        def items
          super.map { |item| item_class.new(item, options) }
        end

        def item_class
          Navigatrix.item_renderers[options[:item]] || options.fetch(:item_class, Item)
        end

        def html_attributes
          HTMLAttributes.new(options[:html_attributes])
        end

        class Item < SimpleDelegator
          include ActionView::Helpers::TagHelper
          include ActionView::Helpers::UrlHelper

          attr_reader :options

          def initialize(item, options = {})
            super(item)
            @options = options
          end

          def render
            content_tag(:li, content, html_attributes) if render?
          end

          private

          def content
            name_or_link + nested_list.to_s
          end

          def name_or_link
            linked? ? link : unlinked_content
          end

          def nested_list
            List.new(children, options).render if has_children?
          end

          def link
            link_to(name, path)
          end

          def unlinked_content
            name
          end

          def name
            super.html_safe
          end

          def html_attributes
            HTMLAttributes.new(super).merge_attribute(:class, html_class)
          end

          def html_class
            active? ? active_class : inactive_class
          end

          def active_class
            options[:active_class] || "active"
          end

          def inactive_class
            options[:inactive_class]
          end
        end

        class HTMLAttributes < HashWithIndifferentAccess
          def merge_attribute(attribute, value)
            return self unless value.present?

            tap do
              self[attribute] = attribute_values(attribute).push(value).join(" ")
            end
          end

          def attribute_values(attribute)
            fetch(attribute, "").to_s.split(" ")
          end
        end
      end
    end
  end
end
