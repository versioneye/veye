require_relative '../base_table.rb'

module Veye
  module Github
    class ListTable < BaseTable
      def initialize
        headings = %w(index fullname language owner_login owner_type private fork)
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
          #row << result['branches'].join(',')
          #row << result['description']
          @table << row
        end
      end
    end
  end
end
