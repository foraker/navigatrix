require "spec_helper"

module Navigatrix
  describe ListBuilder do
    class SimpleList
      def render
      end

      def render_items
        "children"
      end

      def html_attributes
        "class='class'"
      end
    end

    before { ListBuilder.stub(klass: SimpleList) }

    describe "#wrapper" do
      it "wraps rendered items" do
        renderer = ListBuilder.build do |builder|
          builder.wrapper do |content, html_attributes|
            "<li #{html_attributes}>#{content}</li>"
          end
        end

        renderer.new.render.should == "<li class='class'>children</li>"
      end
    end
  end
end