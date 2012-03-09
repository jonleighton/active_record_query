class ActiveRecord::Query
  class Subject < BasicObject
    def initialize(owner, name, table = nil)
      @owner = owner
      @name  = name
      @table = table || @owner.table
    end

    def method_missing(method_name, *args, &block)
      if args.empty? && !block
        Subject.new(@owner, method_name, ::Arel::Table.new(@name))
      else
        ::Kernel.raise ::ArgumentError
      end
    end

    def respond_to?(name, include_private = nil)
      true
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

    def in(value)
      __add__ :in, value
    end

    def not_in(value)
      __add__ :not_in, value
    end

    private

    def __add__(operator, value)
      @owner << @table[@name].send(operator, value)
    end
  end
end
