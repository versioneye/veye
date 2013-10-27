require_relative '../base_table.rb'

module Veye
  module Github
    class ListTable < BaseTable
      def initialize
        headings = %w(index fullname language owner_login owner_type private fork branches imported)
        super("Github repositories", headings)
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
          row << result['branches'].join("\n")
          row << result['imported_projects'].to_a.join("\n")
          #row << result['description']
          @table << row
        end
      end
    end
  end
end
