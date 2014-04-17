require "navigatrix/rendering/strategy_factory"
require "navigatrix/rendering/strategies/content_helpers"
require "navigatrix/rendering/strategies/html_attributes"
require "navigatrix/rendering/strategies/item"

module Navigatrix
  module Rendering
    module Strategies
      class List
        include ContentHelpers

        attr_reader :options, :item_options

        def initialize(items, list_options = {}, item_options = {})
          @items        = items || []
          @options      = list_options
          @item_options = item_options
        end

        def render
          content_tag(:ul, render_items, html_attributes)
        end

        private

        def render_items
          items.map(&:render).join.html_safe
        end

        def items
          @items.map { |item| item_class.new(item, item_options) }
        end

        def item_class
          StrategyFactory.find_item_strategy(item_options[:renderer])
        end

        def html_attributes
          HTMLAttributes.new(options[:html_attributes])
        end
      end
    end
  end
end
