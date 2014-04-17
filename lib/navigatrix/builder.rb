module Navigatrix
  class Builder
    attr_reader :klass

    def self.build(&block)
      instance = new(klass)
      block.call(instance)
      instance.klass
    end

    def initialize(klass)
      @klass = Class.new(klass)
    end

    def define_method(method_name, &block)
      @klass.send(:define_method, method_name, &block)
    end
  end

  class ListBuilder < Builder
    def self.klass
      Navigatrix::Rendering::Strategies::List
    end

    def wrapper(&block)
      define_method(:render) do
        instance_exec(render_items, html_attributes, &block)
      end
    end
  end

  class ItemBuilder < Builder
    def self.klass
      Navigatrix::Rendering::Strategies::Item
    end

    def wrapper(&block)
      define_method(:render) do
        instance_exec(name_or_link, render_children, html_attributes, &block) if render?
      end
    end

    def linked(&block)
      define_method(:linked_content) do
        instance_exec(name, path, &block)
      end
    end

    def unlinked(&block)
      define_method(:unlinked_content) do
        instance_exec(name, path, &block)
      end
    end

    def children_options(&block)
      define_method(:children_options) do
        instance_exec(super(), &block)
      end
    end

    def html_attributes(&block)
      define_method(:html_attributes) do
        instance_exec(&block).inject(super()) do |acc, (key, val)|
          acc.merge_attribute(key, val)
        end
      end
    end
  end
end
