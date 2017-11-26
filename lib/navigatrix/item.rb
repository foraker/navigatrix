require "ostruct"
require 'forwardable'
require "navigatrix/configuration"

module Navigatrix
  class Item < Struct.new(:name, :config, :context)
    extend Forwardable
    delegate :current_path => :context
    delegate [:render?, :html_attributes, :active_class, :inactive_class, :contains_class, :has_children_class] => :config

    def active?
      applicable_active_state? ||
      active_children? ||
      unlinked?
    end

    def contains?
      active_children? && linked?
    end

    def linked?
      !unlinked?
    end

    def unlinked?
      unlinked_states_specified? ? unlinked_states.any?(&:applicable?) : currently_on_path?
    end

    def has_children?
      children.any?
    end

    def children
      @children ||= ItemCollection.new(config.children, context).items
    end

    def path
      @path ||= Path.new(config.path).call(context).to_s
    end

    private

    def active_children?
      children.any?(&:active?)
    end

    def applicable_active_state?
      active_states.any?(&:applicable?)
    end

    def currently_on_path?
      current_path == path.split('#').first
    end

    def unlinked_states_specified?
      unlinked_states.any?
    end

    def active_states
      @active_states ||= config.active_states.map { |active_state| State.new(active_state, context) }
    end

    def unlinked_states
      @unlinked_states ||= config.unlinked_states.map { |unlinked_state| State.new(unlinked_state, context) }
    end

    def config
      @config ||= Configuration.wrap(super)
    end

    class Path < Struct.new(:source)
      def call(context)
        source.respond_to?(:call) ? source.call(context) : source
      end
    end

    class State < OpenStruct
      extend Forwardable
      delegate [:current_path, :controller_name, :action_name] => :context

      attr_reader :context

      def initialize(config, context)
        @context = context
        super(config)
      end

      def applicable?
        path ? path_matches? : (controller_matches? && action_matches?)
      end

      def controller_matches?
        match?(controller, controller_name)
      end

      def action_matches?
        actions.empty? || actions.include?(action_name)
      end

      def path_matches?
        match?(path, current_path)
      end

      def match?(pattern, target)
        pattern.is_a?(Regexp) ? target[pattern] : pattern == target
      end

      def actions
        Array.wrap(super)
      end
    end
  end
end
