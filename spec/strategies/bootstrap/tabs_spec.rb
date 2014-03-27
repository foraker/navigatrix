require "spec_helper"

module Navigatrix::Rendering::Strategies
  module Bootstrap
    describe Tabs do
      include ListRenderingStrategy

      it_should_behave_like "a list rendering strategy"

      describe "#render" do
        it "gives the <ul> a class of 'nav' and 'nav-tabs'" do
          rendered.should have_selector("ul.nav.nav-tabs")
        end
      end
    end
  end
end
