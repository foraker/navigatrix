require "capybara"
require File.expand_path("../../../support/list_rendering_strategy", __FILE__)
require File.expand_path("../../../../lib/navigatrix/rendering/strategies/bootstrap/tabs", __FILE__)

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
