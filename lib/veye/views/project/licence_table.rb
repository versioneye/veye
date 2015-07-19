require_relative '../base_table.rb'

module Veye
  module Project
    class LicenceTable < BaseTable
      def initialize
        headings = %w(index license product_keys)
        super("Licences", headings)
      end
      def format(results)
        items = results['licenses']
        return if items.nil?
        n = 1
        items.each_pair do |license, products|
          products.each do |prod|
            row = [n, license, prod["prod_key"]]
            @table << row
          end
          n += 1
        end
      end
    end
  end
end
