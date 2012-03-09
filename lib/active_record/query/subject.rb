module ActiveRecord::Query
  class Subject
    attr_reader :owner, :name

    def initialize(owner, name, table = nil)
      @owner = owner
      @name  = name
      @table = table
    end

    def table
      @table || owner.table
    end

    def add(operator, value)
      @owner << table[name].send(operator, value)
    end

    def ==(value)
      add :eq, value
    end

    def !=(value)
      add :not_eq, value
    end

    def =~(value)
      add :matches, value
    end

    def !~(value)
      add :does_not_match, value
    end

    def >(value)
      add :gt, value
    end

    def <(value)
      add :lt, value
    end

    def >=(value)
      add :gteq, value
    end

    def <=(value)
      add :lteq, value
    end
  end
end
