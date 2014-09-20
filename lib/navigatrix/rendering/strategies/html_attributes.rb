require "active_support"
require "active_support/core_ext"

module Navigatrix
  module Rendering
    module Strategies
      class HTMLAttributes < HashWithIndifferentAccess
        def merge(other)
          other.inject(self) do |this, (attribute, value)|
            this.merge_attribute(attribute, value)
          end
        end

        def merge_attribute(attribute, value)
          return self unless value.present?

          tap do
            self[attribute] = attribute_values(attribute).push(value).join(" ")
          end
        end

        def attribute_values(attribute)
          fetch(attribute, "").to_s.split(" ")
        end
      end
    end
  end
end
