require 'helper'

module ActiveRecord::Query
  class SubjectTest < MiniTest::Unit::TestCase
    class Column
      attr_reader :table, :name

      def initialize(table, name)
        @table = table
        @name  = name
      end

      def ==(other)
        other.class == self.class &&
          other.table == table &&
          other.name  == name
      end

      PREDICATES = [:eq, :not_eq, :matches, :does_not_match, :gt, :lt, :gteq, :lteq]

      PREDICATES.each do |pred|
        define_method pred do |other|
          [pred, self, other]
        end
      end
    end

    class Table
      def [](name)
        Column.new(self, name)
      end
    end

    def setup
      @owner   = stub
      @table   = Table.new
      @subject = Subject.new(@owner, :foo, @table)
      @column  = @table[:foo]
    end

    def test_equality
      @owner.expects(:<<).with(@column.eq(:bar))
      @subject == :bar
    end

    def test_inequality
      @owner.expects(:<<).with(@column.not_eq(:bar))
      @subject != :bar
    end

    def test_matches
      @owner.expects(:<<).with(@column.matches(:bar))
      @subject =~ :bar
    end

    def test_does_not_match
      @owner.expects(:<<).with(@column.does_not_match(:bar))
      @subject !~ :bar
    end

    def test_gt
      @owner.expects(:<<).with(@column.gt(:bar))
      @subject > :bar
    end

    def test_lt
      @owner.expects(:<<).with(@column.lt(:bar))
      @subject < :bar
    end

    def test_gteq
      @owner.expects(:<<).with(@column.gteq(:bar))
      @subject >= :bar
    end

    def test_lteq
      @owner.expects(:<<).with(@column.lteq(:bar))
      @subject <= :bar
    end

    def test_method_missing
      table = stub
      sub2  = stub

      Arel::Table.expects(:new).with(:foo).returns(table)
      Subject.expects(:new).with(@owner, :bar, table).returns(sub2)

      assert_equal sub2, @subject.bar
    end
  end
end
