require 'terminal-table'

module Veye
  module Github
    class GithubSearchTable
      @@columns = %w(index name language owner_name owner_type private fork watchers forks github_url)
      def before
        @table = Terminal::Table.new :title => "Github repository search",
                                      :headings => @@columns

        @table.align_column(0, :right)
      end

      def after(paging = nil)
        unless paging.nil?
          paging_header = ['p', 'current_page', 'per_page', 'total_pages', 'total_entries']
          paging_data = ["p"]
          paging.each_pair do |key, val| 
            paging_data << val
          end
          
          @table.add_separator
          @table << paging_header
          @table << paging_data
        end

        puts @table.to_s
      end

      def format(results)
        results['results'].each_with_index do |result, index|
          print_row(result, index)
        end
      end

      def print_row(result, index)
        row = [(index + 1)]
        row << result['name']
        row << result['language']
        row << result['owner_name']
        row << result['owner_type']
        row << result['private']
        row << result['fork']
        row << result['watchers']
        row << result['forks']
        row << result['git_url']

        @table << row
      end
    end
  end
end

