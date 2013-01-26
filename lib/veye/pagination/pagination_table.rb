require 'terminal-table'

module Veye
  module Pagination
    class PaginationTable
      def before
        @@table = Terminal::Table.new :title => "Pagination",
                                      :headings => %w(current_page per_page total_pages total_entries)
        @@table.align_column(0, :right)
      end

      def after
        puts @@table.to_s
      end

      def format(paging)
        row = [paging['current_page'], paging['per_page'], paging['total_pages'], paging['total_entries']]
        @@table << row
      end
    end
  end
end
