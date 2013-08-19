module Navigatrix
  module Rendering
    class Context < Struct.new(:wrapped)
      extend Forwardable
      delegate :request => :wrapped

      def current_path
        request.env["PATH_INFO"]
      end

      def controller_name
        attempt_delegation(:controller_name)
      end

      def action_name
        attempt_delegation(:action_name)
      end

      private

      def attempt_delegation(method)
        wrapped.send(method) if wrapped.respond_to?(method)
      end
    end
  end
end