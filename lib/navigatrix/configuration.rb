require "active_support"
require "active_support/core_ext"

module Navigatrix
  module Configuration
    def self.wrap(wrapped)
      wrapped.is_a?(Hash) ? AdvancedConfig.new(wrapped) : BasicConfig.new(wrapped)
    end

    class BasicConfig < Struct.new(:path)
      def active_states
        [{path: path}]
      end

      def unlinked_states
        active_states
      end

      def children
        {}
      end

      def html_attributes
        {}
      end

      def active_class
        nil
      end

      def inactive_class
        nil
      end

      def contains_class
        nil
      end

      def has_children_class
        nil
      end

      def render?
        true
      end
    end

    class AdvancedConfig < OpenStruct
      DEFAULTS = {
        :active_class         => nil,
        :inactive_class       => nil,
        :contains_class       => nil,
        :has_children_class   => nil,
        :html_attributes      => {},
        :render?              => true,
        :children             => {}
      }

      def initialize(raw_config)
        super(DEFAULTS.merge(raw_config) || {})
      end

      def active_states
        Array.wrap(super)
      end

      def unlinked_states
        Array.wrap(super)
      end
    end
  end
end
