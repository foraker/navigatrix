require "spec_helper"
require "navigatrix/rendering/strategies/html_attributes"

module Navigatrix
  describe ItemBuilder do
    class SimpleItem
      def name_or_link
        "name_or_link"
      end

      def linked_content
        "linked_content"
      end

      def unlinked_content
        "unlinked_content"
      end

      def render_children
        "children"
      end

      def name
        "name"
      end

      def path
        "/path"
      end

      def html_attributes
        Rendering::Strategies::HTMLAttributes.new({class: "class"})
      end

      def children_options
        {class: "class"}
      end

      def render?
        true
      end
    end

    describe ItemBuilder do
      before { described_class.stub(klass: SimpleItem) }

      describe "#wrapper" do
        it "wraps rendered items" do
          renderer = described_class.build do |builder|
            builder.wrapper do |content, children, html_attributes|
              "<li class='#{html_attributes[:class]}'>#{content}<div>#{children}</div></li>"
            end
          end
          rendered = renderer.new.render

          rendered.should == "<li class='class'>name_or_link<div>children</div></li>"
        end
      end

      describe "#linked" do
        it "overrides the linked content" do
          renderer = described_class.build do |builder|
            builder.linked do |name, path|
              "<span>#{name}</span>"
            end
          end

          renderer.new.linked_content.should == "<span>name</span>"
        end
      end

      describe "#unlinked" do
        it "overrides the unlinked content" do
          renderer = described_class.build do |builder|
            builder.linked do |name, path|
              "<span>#{name}</span>"
            end
          end

          renderer.new.linked_content.should == "<span>name</span>"
        end
      end

      describe "#children_options" do
        it "merges options" do
          renderer = described_class.build do |builder|
            builder.children_options do |defaults|
              defaults.merge({
                item: {
                  renderer: "child"
                }
              })
            end
          end

          renderer.new.children_options.should == {
            class: "class",
            item: {
              renderer: "child"
            }
          }
        end
      end

      describe "#html_attributes" do
        it "merges the options" do
          renderer = described_class.build do |builder|
            builder.html_attributes do |defaults|
              {class: "hide"}
            end
          end

          renderer.new.html_attributes.should == {
            "class" => "class hide"
          }
        end
      end
    end
  end
end
