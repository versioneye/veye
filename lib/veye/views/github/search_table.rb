require_relative '../base_table.rb'

module Veye
  module Github
    class SearchTable < BaseTable
      def initialize
        headings = %w(index name language owner_name owner_type private fork watchers forks github_url)
        super("Search results", headings)
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

