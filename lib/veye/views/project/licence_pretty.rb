require_relative '../base_pretty.rb'


module Veye
  module Project
    class LicencePretty < BasePretty
      def format(results)
        return if result.nil?
        n = 1
        results["licenses"].each_pair do |licence, products|
          product_keys = products.map {|prod| prod["prod_key"]}
          licence_name = "#{licence}".color(:green).bright
          printf("%3d - %s\n", n, licence_name)
          printf("\t%-15s : %s\n", "Products", product_keys.join(", "))

          n += 1
        end
      end
    end
  end
end
