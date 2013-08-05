require "active_support/core_ext"

module Navigatrix
  class Configuration < OpenStruct
    def initialize(raw_config)
      super(raw_config || {})
    end

    def active
      Array.wrap(super)
    end

    def unlinked
      Array.wrap(super)
    end

    def children
      super || {}
    end
  end
end
