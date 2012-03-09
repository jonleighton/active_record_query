module ActiveRecord::Query
  class And < Abstract
    def arel
      ::Arel::Nodes::And.new(@nodes)
    end

    def __class__
      And
    end

    def <<(node)
      super
      true
    end
  end
end
