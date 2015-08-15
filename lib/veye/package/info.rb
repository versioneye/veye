require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    class Info < BaseExecutor
      @@output_formats = {
        'csv'       => Package::InfoCSV.new,
        'json'      => Package::InfoJSON.new,
        'pretty'    => Package::InfoPretty.new,
        'table'     => Package::InfoTable.new
      }

      def self.get_package(package_key, options = {})
        prod_key, lang = parse_package_key(package_key)
        results  = Veye::API::Package.get_package(prod_key, lang)
        if valid_response?(results, "Didnt find any package with product_key: `#{package_key}`")
          show_results(@@output_formats, results.data, options, results.data['paging'])
        end
      end
    end
  end
end
