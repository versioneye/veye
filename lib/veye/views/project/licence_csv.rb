require_relative '../base_csv.rb'

module Veye
  module Project
    class LicenceCSV < BaseCSV
      def initialize
        headers = "nr,licence,product_keys"
        super(headers)
      end
      def format(results)
        return nil if results.nil?
        n = 1
        results["licenses"].each_pair do |licence, prods|
          prod_keys = prods.map {|p| p["prod_key"]}
          printf("%d,%s,%s\n", n, licence, prod_keys.join(','))
          n += 1
        end
      end
    end
  end
end
