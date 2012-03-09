require 'helper'

module ActiveRecord
  class QueryTest < MiniTest::Unit::TestCase
    def setup
      @table = :table
      @query = Query::And.new(@table)
    end

    def test_method_missing
      assert_raises(NoMethodError) { @query.title(:foo) }
      assert_raises(NoMethodError) { @query.title { :foo } }

      @query.title.tap do |s|
        assert_equal Query::Subject, s.class
        assert_equal @query, s.owner
        assert_equal :title, s.name
      end
    end

    def test_table
      assert_equal @table, @query.table
    end

    def test_push
      @query << :foo
      @query << :bar

      assert_equal [:foo, :bar], @query.arel.children
    end

    def test_inspect
      assert_equal "#<ActiveRecord::Query::And table=:table>", @query.inspect
    end
  end
end
