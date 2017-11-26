require "delegate"

require "navigatrix/rendering/strategy_factory"
require "navigatrix/rendering/strategies/html_attributes"
require "navigatrix/rendering/strategies/content_helpers"

module Navigatrix
  module Rendering
    module Strategies
      class Item < SimpleDelegator
        include ContentHelpers

        attr_reader :options

        def initialize(item, options = {})
          super(item)
          @options = options || {}
        end

        def render
          content_tag(:li, content, html_attributes) if render?
        end

        private

        def content
          name_or_link + render_children
        end

        def name_or_link
          linked? ? linked_content : unlinked_content
        end

        def linked_content
          link_to(name, path)
        end

        def unlinked_content
          name
        end

        def name
          super.html_safe
        end

        def html_attributes
          universal_attributes
            .merge(super)
            .merge_attribute(:class, html_class)
        end

        def universal_attributes
          HTMLAttributes.new(options[:html_attributes])
        end

        def render_children
          if has_children?
            children_renderer.new(
              children,
              children_list_options,
              children_item_options
            ).render
          else
            ""
          end
        end

        def children_options
          options
        end

        def html_class
          output = []
          if has_children?
            output << has_children_class
          end
          if contains?
            output << contains_class
          elsif active?
            output << active_class
          else
            output << inactive_class
          end
          output.compact.join(' ')
        end

        def active_class
          super.presence || options[:active_class] || "active"
        end

        def inactive_class
          super.presence || options[:inactive_class]
        end

        def contains_class
          super.presence || options[:contains_class]
        end

        def has_children_class
          options[:has_children_class] || "has-children"
        end

        def children_renderer
          StrategyFactory.find_list_strategy(strategy_name)
        end

        def strategy_name
          children_list_options[:renderer]
        end

        def children_list_options
          children_options.fetch(:list, {})
        end

        def children_item_options
          children_options.fetch(:item, {})
        end
      end
    end
  end
end
