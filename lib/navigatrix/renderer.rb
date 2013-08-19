require "navigatrix/rendering/context"
require "navigatrix/rendering/strategies/list"
require "navigatrix/rendering/strategies/bootstrap/navbar"
require "navigatrix/rendering/strategies/bootstrap/tabs"

module Navigatrix
  class Renderer
    attr_reader :configuration, :strategy, :render_context, :render_options

    REGISTERED_STRATEGIES = {
      :unordered_list   => Rendering::Strategies::List,
      :bootstrap_navbar => Rendering::Strategies::Bootstrap::Navbar,
      :bootstrap_tabs   => Rendering::Strategies::Bootstrap::Tabs
    }

    class MissingStrategy < NameError ; end

    def initialize(configuration, options)
      @configuration  = configuration
      @strategy       = find_strategy(options.delete(:strategy))
      @render_context = Rendering::Context.new(options.delete(:render_context))
      @render_options = options
    end

    def render
      strategy.new(item_collection.items, render_options).render
    end

    private

    def item_collection
      ItemCollection.new(configuration, render_context)
    end

    def find_strategy(strategy_or_name)
      return strategy_or_name if strategy_or_name.is_a?(Class)
      strategy_or_name ||= :unordered_list
      REGISTERED_STRATEGIES[strategy_or_name] || raise(MissingStrategy, "can't find strategy #{strategy_name}")
    end
  end
end
