require_relative '../base_table.rb'

module Veye
  module Package
    class VersionsTable < BaseTable
      def initialize
        headings = %w(nr name version released_at product_key language product_type)
        super('Package versions', headings)
      end

      def format(results, n = 10, from = 0)
        return if results.nil?

        results['versions'].to_a.each_with_index do |ver, i|
          row = [
            (from + i + 1), results['name'], ver['version'], ver['released_at'],
            results['prod_key'], results['language'], results['prod_type']
          ]
        
          @table << row
        end
        
        @table
      end
    end
  end
end
