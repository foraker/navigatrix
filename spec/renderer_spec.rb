require File.expand_path("../../lib/navigatrix/renderer", __FILE__)

module Navigatrix
  describe Renderer do
    describe "#render" do
      class StrategyDouble
        attr_reader :items, :options, :klass

        def initialize(items, options, klass = nil)
          @items   = items
          @options = options
          @klass   = klass
        end

        def render
          @rendered = true
          self
        end

        def rendered?
          @rendered
        end

        def rendered_strategy?(strategy_klass)
          puts klass
          puts strategy_klass
          rendered? and klass == strategy_klass
        end
      end

      let(:rendering_context) { double }
      let(:config)            { double }
      let(:item_collection)   { double(:items => double) }

      before do
        wrapped_context = double
        Rendering::Context.stub(:new).with(rendering_context).and_return(wrapped_context)
        ItemCollection.stub(:new).with(config, wrapped_context).and_return(item_collection)
      end

      context "a specified strategy" do
        subject { render(:strategy => StrategyDouble) }

        it "renders via the strategy" do
          subject.should be_rendered
        end

        it "passes the items to be rendered" do
          subject.items.should == item_collection.items
        end

        it "passes the rendering options" do
          subject.options.should == {:render_option  => "an option"}
        end
      end

      it "finds strategies by name" do
        stub_const("Navigatrix::Renderer::REGISTERED_STRATEGIES", {:bootstrap => StrategyDouble})
        render({:strategy => :bootstrap}).should be_rendered
      end

      it "defaults to the unordered_list strategy" do
        stub_const("Navigatrix::Renderer::REGISTERED_STRATEGIES", {:unordered_list => StrategyDouble})
        render({:strategy => nil}).should be_rendered
      end

      def render(options)
        defaults = {
          :render_context => rendering_context,
          :render_option  => "an option"
        }

        Renderer.new(config, defaults.merge(options)).render
      end
    end
  end
end