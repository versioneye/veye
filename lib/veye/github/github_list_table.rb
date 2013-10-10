require 'terminal-table'

module Veye
  module Github
    class GithubListTable
      @@columns = %w(index fullname language owner_login owner_type private fork)
      def before
        @@table = Terminal::Table.new :title => "Github repositories",
                                      :headings => @@columns
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
        results['repos'].each_with_index do |result, index|
          row = [(index + 1)]
          row << result['fullname']
          row << result['language']
          row << result['owner_login']
          row << result['owner_type']
          row << result['private']
          row << result['fork']
          #row << result['branches'].join(',')
          #row << result['description']
          @@table << row
        end
      end
    end
  end
end
