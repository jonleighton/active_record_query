require 'active_record'
require 'helper'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string :title
  end

  create_table :comments do |t|
    t.references :post
    t.string :author
  end
end

class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
end

module ActiveRecord
  class QueryIntegrationTest < MiniTest::Unit::TestCase
    def setup
      @hello   = Post.create(title: 'Hello')
      @goodbye = Post.create(title: 'Goodbye')

      @hello.comments.create(author: 'Jon')
    end

    def teardown
      Post.delete_all
    end

    # Checks that none of the operators blow up
    def test_operators
      Post.where do |q|
        q.title == 'x'
        q.title != 'x'
        q.title =~ 'x'
        q.title !~ 'x'
        q.title > 'x'
        q.title < 'x'
        q.title >= 'x'
        q.title <= 'x'
        q.title.in 'x'
        q.title.not_in 'x'
      end
    end

    def test_basic_query
      assert_equal [@hello], Post.where { |q| q.title == 'Hello' }
    end

    def test_and_query
      assert_equal [@hello], Post.where { |q| q.title == 'Hello' && q.title =~ 'Hell%' }
      assert_equal [], Post.where { |q| q.title == 'Hello' && q.title == 'Goodbye' }
    end

    def test_or_query
      assert_equal [@hello, @goodbye], Post.any { |q| q.title == 'Hello' || q.title == 'Goodbye' }
      assert_equal [@hello], Post.any { |q| q.title == 'Hello' || q.title == 'non-existent' }
      assert_equal [@hello], Post.any { |q| q.title == 'non-existent' || q.title == 'Hello' }
    end

    def test_other_table_query
      assert_equal [@hello], Post.joins(:comments).where { |q| q.comments.author == 'Jon' }
      assert_equal [], Post.joins(:comments).where { |q| q.comments.author == 'Bob' }
    end
  end
end
