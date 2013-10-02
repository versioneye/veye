require 'rainbow'

module Veye
  module Project
    class ProjectLicencePretty
      def before; end
      def after; end

      def format(results)
        
        n = 1
        results["licenses"].each_pair do |licence, products|
          product_keys = products.map {|prod| prod["prod_key"]}
          licence_name = "#{licence}".foreground(:green).bright
          printf("%3d - %s\n", n, licence_name)
          printf("\t%-15s : %s\n", "Products", product_keys.join(", "))

          n += 1
        end
      end
    end
  end
end
