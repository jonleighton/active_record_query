class ActiveRecord::Query
  class Context
    attr_reader :nodes

    def initialize
      @nodes = []
    end

    def <<(node)
      @nodes << node
    end

    def arel
      Arel::Nodes::Grouping.new(nodes)
    end
  end

  class Or < Context
    def nodes
      @nodes.inject { |mem, node| Arel::Nodes::Or.new(mem, node) }
    end

    def <<(node)
      super
      false
    end
  end

  class And < Context
    def nodes
      Arel::Nodes::And.new(@nodes)
    end

    def <<(node)
      super
      true
    end
  end
end
