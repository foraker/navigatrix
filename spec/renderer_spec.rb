require "spec_helper"

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
          rendered? and klass == strategy_klass
        end
      end

      let(:rendering_context) { double }
      let(:config)            { double }
      let(:item_collection)   { double(:items => double) }

      before do
        Rendering::StrategyFactory.stub(:find_list_strategy)
          .with("list")
          .and_return(StrategyDouble)

        wrapped_context = double
        Rendering::Context.stub(:new)
          .with(rendering_context)
          .and_return(wrapped_context)

        ItemCollection.stub(:new)
          .with(config, wrapped_context)
          .and_return(item_collection)
      end

      describe "#render" do
        subject { render }

        it "renders via the strategy" do
          subject.should be_rendered
        end

        it "passes the items to be rendered" do
          subject.items.should == item_collection.items
        end

        it "passes the rendering options" do
          subject.options.should == {
            :renderer      =>"list",
            :render_option => "an option"
          }
        end
      end

      def render(options = {})
        defaults = {
          :render_context => rendering_context,
          :list => {
            :renderer      => "list",
            :render_option => "an option"
          }
        }

        Renderer.new(config, defaults.merge(options)).render
      end
    end
  end
end