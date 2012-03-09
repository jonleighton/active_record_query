module ActiveRecord::Query
  class Subject < BasicObject
    def initialize(owner, name, table = nil)
      @owner = owner
      @name  = name
      @table = table || @owner.table
    end

    def method_missing(method_name, *args, &block)
      unless args.empty? && !block
        super
      else
        Subject.new(@owner, method_name, ::Arel::Table.new(@name))
      end
    end

    def ==(value)
      __add__ :eq, value
    end

    def !=(value)
      __add__ :not_eq, value
    end

    def =~(value)
      __add__ :matches, value
    end

    def !~(value)
      __add__ :does_not_match, value
    end

    def >(value)
      __add__ :gt, value
    end

    def <(value)
      __add__ :lt, value
    end

    def >=(value)
      __add__ :gteq, value
    end

    def <=(value)
      __add__ :lteq, value
    end

    private

    def __add__(operator, value)
      @owner << @table[@name].send(operator, value)
    end
  end
end
