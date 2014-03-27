require "spec_helper"

module Navigatrix::Rendering::Strategies
  module Bootstrap
    describe Navbar do
      include ListRenderingStrategy

      it_should_behave_like "a list rendering strategy"

      describe "#render" do
        it "gives the <ul> a class of 'nav'" do
          rendered.should have_selector("ul.nav")
        end
      end

      describe "a list item" do
        it "does not have a class of 'dropdown'" do
          rendered_item["class"].should be_nil
        end

        context "with children" do
          before do
            item.stub(:has_children? => true, :children => [])
          end

          it "gives the item a class of 'dropdown'" do
            rendered_item["class"].should include("dropdown")
          end

          it "includes an icon" do
            rendered_item.should have_selector("i.icon-chevron-down.icon-white")
          end

          it "allows an icon specification" do
            rendered_item(:dropdown_icon => "<i class='alt-icon'>ABC</i>".html_safe)
              .should have_selector("i.alt-icon")
          end
        end
      end
    end
  end
end
