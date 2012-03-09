module ActiveRecord::Query
  class Or < Abstract
    def arel
      ::Arel::Nodes::Grouping.new(
        @nodes.inject { |mem, node| ::Arel::Nodes::Or.new(mem, node) }
      )
    end

    def __class__
      Or
    end

    def <<(node)
      super
      false
    end
  end
end
