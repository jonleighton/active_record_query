module ActiveRecord::Query
  class And < Abstract
    def arel
      ::Arel::Nodes::And.new(@nodes)
    end
  end
end
