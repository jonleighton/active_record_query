require 'ar_query/version'
require 'active_record/query'

if defined?(ActiveRecord::Base)
  require 'ar_query/relation_extension'
end
