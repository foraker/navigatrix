module Navigatrix
  class ItemCollection < Struct.new(:configuration, :context)
    extend Forwardable
    def_delegator :items, :each

    def items
      configuration.map { |name, config| Item.new(name, config, context) }
    end
  end
end