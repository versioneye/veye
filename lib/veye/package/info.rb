require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    # View an detailed information of the package.
    class Info < BaseExecutor
      @output_formats = {
        'csv'       => Package::InfoCSV.new,
        'json'      => Package::InfoJSON.new,
        'pretty'    => Package::InfoPretty.new,
        'table'     => Package::InfoTable.new
      }

      def self.get_package(package_key, options = {})
        prod_key, lang = Package.parse_key(package_key)
        results = Veye::API::Package.get_package(prod_key, lang)
        err_msg = "Didnt find any package with product_key: `#{package_key}`"
        if valid_response?(results, err_msg)
          paging = results.data['paging']
          show_results(@output_formats, results.data, options, paging)
        end
      end
    end
  end
end
