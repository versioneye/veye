require_relative '../base_table.rb'

module Veye
  module Package
    class SearchTable < BaseTable
      def initialize
        headings = %w(index name version product_key language group_id)
        super("Package search", headings)
      end

      def format(results)
        items = results['results']
        return if items.nil?
        items.each_with_index do |result, index|
          row = [index+1, result["name"], result["version"], result["prod_key"]]
          row << result["language"]
          row << result["group_id"]

          @table << row
        end
      end
    end

  end
end
