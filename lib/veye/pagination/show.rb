require_relative 'pagination_csv.rb'
require_relative 'pagination_json.rb'
require_relative 'pagination_pretty.rb'
require_relative 'pagination_table.rb'

module Veye
  module Pagination
    class Show
      @@pagination_formats = {
        'csv'     => PaginationCSV.new,
        'json'    => PaginationJSON.new,
        'pretty'  => PaginationPretty.new,
        'table'   => PaginationTable.new
      }

      def self.format(paging, format = 'pretty')
        formatter = @@pagination_formats[format]
        
        formatter.before
        formatter.format paging
        formatter.after
      end
    end
  end
end

