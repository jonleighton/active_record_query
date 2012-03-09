require 'helper'

module ARQuery
  class RelationExtensionTest < MiniTest::Unit::TestCase
    class FakeRelation
      module Where
        attr_reader :where_values

        def where(*args)
          @where_values = args
        end
      end

      include Where
      include RelationExtension

      def table
        :table
      end
    end

    def setup
      @relation = FakeRelation.new
      @query    = stub(:arel => stub)
    end

    def test_where_with_args
      @relation.where :foo
      assert_equal [:foo], @relation.where_values

      @relation.where(:foo) { :bar }
      assert_equal [:foo], @relation.where_values
    end

    def test_where_with_block
      ActiveRecord::Query.expects(:new).with(:table, :and).returns(@query)

      query = nil
      @relation.where { |q| query = q }

      assert_equal @query, query
      assert_equal [@query.arel], @relation.where_values
    end

    def test_any
      ActiveRecord::Query.expects(:new).with(:table, :or).returns(@query)

      query = nil
      @relation.any { |q| query = q }

      assert_equal @query, query
      assert_equal [@query.arel], @relation.where_values
    end
  end
end
