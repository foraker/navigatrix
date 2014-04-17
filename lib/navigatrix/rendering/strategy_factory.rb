module Navigatrix
  module Rendering
    class StrategyFactory
      DEFAULT_LIST_STRATEGY = :unordered_list
      DEFAULT_ITEM_STRATEGY = :item

      class MissingStrategy < NameError ; end

      def self.find_list_strategy(strategy_or_name, strategies = Navigatrix.list_renderers)
        find_strategy(strategy_or_name, strategies, DEFAULT_LIST_STRATEGY)
      end

      def self.find_item_strategy(strategy_or_name, strategies = Navigatrix.item_renderers)
        find_strategy(strategy_or_name, strategies, DEFAULT_ITEM_STRATEGY)
      end

      def self.find_strategy(strategy_or_name, strategies, default)
        return strategy_or_name if strategy_or_name.is_a?(Class)

        strategy_or_name ||= default

        strategies.fetch(strategy_or_name) do
          raise(MissingStrategy, "can't find strategy #{strategy_or_name}")
        end
      end
    end
  end
end
