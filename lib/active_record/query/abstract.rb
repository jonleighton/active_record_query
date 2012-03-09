module ActiveRecord::Query
  class Abstract < BasicObject
    attr_reader :table

    def initialize(table)
      @table = table
      @nodes = []
    end

    def method_missing(name, *args, &block)
      if args.empty? && !block
        Subject.new(self, name)
      else
        super
      end
    end

    def <<(node)
      @nodes << node
    end

    def arel
      ::Kernel.raise ::NotImplementedError
    end

    def __class__
      ::Kernel.raise ::NotImplementedError
    end

    def inspect
      "#<#{__class__} table=#{table.inspect}>"
    end
  end
end
