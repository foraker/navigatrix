require "spec_helper"

module Navigatrix
  module Rendering
    module Strategies
      describe List do
        include ListRenderingStrategy

        it_should_behave_like "a list rendering strategy"
      end
    end
  end
end
