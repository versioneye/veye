require_relative '../base_table.rb'

module Veye
  module Package
    class InfoTable < BaseTable
      def initialize
        headings = %w(name version product_key language license description)
        super("Package information", headings)
      end
      def format(results)
        result = results
        return if result.nil?

        row = [result["name"], result["version"], result["prod_key"]]
        row << result["language"]
        row << result["license_info"]
        row << result["description"]

        @table << row
      end
    end

  end
end

