require 'active_support/core_ext/module/delegation'

module ARQuery
  module RelationExtension
    def where(*args)
      if args.empty? && block_given?
        query = ActiveRecord::Query::And.new(table)
        yield query
        super query.arel
      else
        super
      end
    end

    def any
      query = ActiveRecord::Query::Or.new(table)
      yield query
      where(query.arel)
    end
  end
end

if defined?(ActiveRecord::Base)
  require 'active_record/relation'

  class ActiveRecord::Relation
    include ARQuery::RelationExtension
  end

  class << ActiveRecord::Base
    delegate :any, :to => :scoped
  end
end
