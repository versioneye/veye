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
        tokens = package_key.to_s.split('/')
        lang = tokens.first
        prod_key = tokens.drop(1).join("/")

        if lang.nil? or prod_key.nil?
          msg =  %Q[
            You missed language or product key.
            Example: clojure/ztellman/aleph, as structured <prog lang>/<product_code>
          ]
          printf("%s. \n%s", "Error: Malformed key.".color(:red), msg)
          exit
        end

        results  = Veye::API::Package.get_package(prod_key, lang)
        if valid_response?(results, "Didnt find any package with product_key: `#{package_key}`")
          show_results(@@output_formats, results.data, options, results.data['paging'])
        end
      end
    end
  end
end
