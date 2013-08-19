require "capybara"
require File.expand_path("../../support/list_rendering_strategy", __FILE__)
require File.expand_path("../../../lib/navigatrix/rendering/strategies/list", __FILE__)

module Navigatrix::Rendering::Strategies
  describe List do
    include ListRenderingStrategy

    it_should_behave_like "a list rendering strategy"
  end
end
