require 'active_record/relation'

module ArQuery
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
  end
end

class ActiveRecord::Relation
  include ArQuery::RelationExtension
end
