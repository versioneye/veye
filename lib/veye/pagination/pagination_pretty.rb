require 'rainbow'
require 'rainbow/ext/string'

module Veye
  module Pagination
    class PaginationPretty
      def before; end
      def after; end

      def format(paging)
        printf("\t%15s - %s\n",
               "Current page".color(:green).bright,
               "#{paging['current_page']}".bright)
        puts "\t-------------------------"
        printf("\t%-15s: %s\n", "Per page", paging['per_page'])
        printf("\t%-15s: %s\n", "Total pages", paging['total_pages'])
        printf("\t%-15s: %s\n", "Total entries", paging['total_entries'])

      end
    end
  end
end

