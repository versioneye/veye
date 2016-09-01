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

      def self.get_package(api_key, prod_key, lang = 'ruby', version = nil, options = {})
        results = Veye::API::Package.get_package(api_key, prod_key, lang, version)
        err_msg = "Didnt find any #{lang} package with product_key: `#{prod_key}`"

        if valid_response?(results, err_msg)
          paging = results.data['paging']
          show_results(@output_formats, results.data, options, paging)
        end
      end
    end
  end
end
