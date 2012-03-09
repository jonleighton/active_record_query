require 'helper'

module ActiveRecord
  class QueryTest < MiniTest::Unit::TestCase
    def setup
      @table = :table
      @query = Query.new(@table, :and)
      class << @query; include ::Mocha::ObjectMethods; end
    end

    def test_method_missing
      assert_raises(NoMethodError) { @query.title(:foo) }
      assert_raises(NoMethodError) { @query.title { :foo } }

      subject = stub
      Query::Subject.expects(:new).with(@query, :title).returns(subject)
      assert_equal subject, @query.title
    end

    def test_table
      assert_equal @table, @query.table
    end

    def test_push
      @query << :foo
      @query << :bar

      assert_equal [:foo, :bar], @query.arel.expr.children
    end

    def test_inspect
      assert_equal "#<ActiveRecord::Query table=:table>", @query.inspect
    end

    def test_and
      subcontext = stub(:arel => stub)
      subject    = stub
      Query::And.expects(:new).returns(subcontext)

      @query.and { }
      assert_equal [subcontext.arel], @query.arel.expr.children
    end

    def test_or
      subcontext = stub(:arel => stub)
      subject    = stub
      Query::Or.expects(:new).returns(subcontext)

      @query.or { }
      assert_equal [subcontext.arel], @query.arel.expr.children
    end
  end
end
