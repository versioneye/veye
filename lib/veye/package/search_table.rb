require 'terminal-table'

module Veye
  module Package
    class SearchTable
      def before
        @@table = Terminal::Table.new :title => "Package search",
                                      :headings => %w(index name version product_key language group_id)
        @@table.align_column(0, :right)
      end

      def after(paging = nil)
        unless paging.nil?
          paging_header = ['p', 'current_page', 'per_page', 'total_pages', 'total_entries']
          paging_data = ["p"]
          paging.each_pair do |key, val| 
            paging_data << val
          end
          
          @@table.add_separator
          @@table << paging_header
          @@table << paging_data
        end

        puts @@table.to_s
      end

      def format(results)
        results.each_with_index do |result, index|
          row = [index+1, result["name"], result["version"], result["prod_key"]]
          row << result["language"]
          row << result["group_id"]

          @@table << row
        end
      end
    end

  end
end
