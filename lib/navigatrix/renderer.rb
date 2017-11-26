require "navigatrix/rendering/context"
require "navigatrix/rendering/strategy_factory"
require "navigatrix/rendering/strategies/list"
require "navigatrix/rendering/strategies/bootstrap/navbar"
require "navigatrix/rendering/strategies/bootstrap/tabs"

module Navigatrix
  class Renderer
    attr_reader :configuration, :strategy, :render_context, :render_options

    def initialize(configuration, options)
      @configuration  = configuration
      @render_context = Rendering::Context.new(options.delete(:render_context))
      @render_options = options
    end

    def render
      strategy.new(item_collection.items, list_options, item_options).render
    end

    private

    def item_collection
      ItemCollection.new(configuration, render_context)
    end

    def strategy
      Rendering::StrategyFactory.find_list_strategy(strategy_name)
    end

    def strategy_name
      render_options.fetch(:list, {})[:renderer]
    end

    def list_options
      base = render_options[:html_attributes]
      (base ? {html_attributes: base} : {})
        .merge(render_options.fetch(:list, {}))
    end

    def item_options
      render_options
        .slice(:active_class, :inactive_class, :contains_class, :has_children_class)
        .merge(render_options.fetch(:item, {}))
    end
  end
end
