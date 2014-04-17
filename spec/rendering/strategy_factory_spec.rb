module Navigatrix
  module Rendering
    describe StrategyFactory do
      describe ".find_list_strategy" do
        let(:bootstrap_strategy) { Class.new }
        let(:default_strategy)   { double }
        let(:strategies) do
          {
            :unordered_list => default_strategy,
            :bootstrap      => bootstrap_strategy
          }
        end

        it "returns a strategy class" do
          strategy = described_class.find_list_strategy(bootstrap_strategy, strategies)
          strategy.should == bootstrap_strategy
        end

        it "finds strategies by name" do
          strategy = described_class.find_list_strategy(:bootstrap, strategies)
          strategy.should == bootstrap_strategy
        end

        it "defaults to the unordered_list strategy" do
          strategy = described_class.find_list_strategy(nil, strategies)
          strategy.should == default_strategy
        end
      end

      describe ".find_item_strategy" do
        let(:bootstrap_strategy) { Class.new }
        let(:default_strategy)   { double }
        let(:strategies) do
          {
            :item      => default_strategy,
            :bootstrap => bootstrap_strategy
          }
        end

        it "returns a strategy class" do
          strategy = described_class.find_item_strategy(bootstrap_strategy, strategies)
          strategy.should == bootstrap_strategy
        end

        it "finds strategies by name" do
          strategy = described_class.find_item_strategy(:bootstrap, strategies)
          strategy.should == bootstrap_strategy
        end

        it "defaults to the unordered_list strategy" do
          strategy = described_class.find_item_strategy(nil, strategies)
          strategy.should == default_strategy
        end
      end
    end
  end
end

