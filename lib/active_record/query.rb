require 'arel'

module ActiveRecord
  class Query < BasicObject
    ::Kernel.require 'active_record/query/subject'
    ::Kernel.require 'active_record/query/context'

    CONTEXT = {
      :or  => Or,
      :and => And
    }

    attr_reader :table

    def initialize(table, context)
      @table = table
      @nodes = []
      @stack = [CONTEXT[context].new]
    end

    def method_missing(name, *args, &block)
      if args.empty? && !block
        Subject.new(self, name)
      else
        super
      end
    end

    def and
      @stack << And.new
      yield
      self << @stack.pop.arel
    end

    def or
      @stack << Or.new
      yield
      self << @stack.pop.arel
    end

    def <<(node)
      @stack.last << node
    end

    def arel
      @stack.last.arel
    end

    def inspect
      "#<ActiveRecord::Query table=#{table.inspect}>"
    end
  end
end
