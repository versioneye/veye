require_relative '../base_csv.rb'

module Veye
  module Project
    class LicenceCSV < BaseCSV
      def initialize
        headers = "nr,license,product_keys"
        super(headers)
      end
      def format(results)
        return nil if results.nil?
        n = 1
        results["licenses"].each_pair do |license, prods|
          prod_keys = prods.map {|p| p["prod_key"]}
          printf("%d,%s,%s\n", n, license, prod_keys.join(','))
          n += 1
        end
      end
    end
  end
end
