require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    module API
      def self.get_package(package_key, options = {})
        product_api = Veye::API::Resource.new(RESOURCE_PATH)
        tokens = package_key.to_s.split('/')
        lang = Package.encode_language(tokens.first)
        safe_prod_key = Package.encode_prod_key(tokens.drop(1).join("/"))


        if lang.nil? or safe_prod_key.nil?
          msg =  %Q[
            You missed language or product key.
            Example: clojure/ztellman/aleph, which as required structure <prog lang>/<product_code>
          ]
          printf("%s. \n%s",
                 "Error: Malformed key.".color(:red),
                  msg)
          exit
        end

        results = nil
        product_api.resource["/#{lang}/#{safe_prod_key}"].get do |response, request, result, &block|
          results = Veye::API::JSONResponse.new(request, result, response)
        end
        return results
      end
    end

    class Info < BaseExecutor
      @@output_formats = {
        'csv'       => Package::InfoCSV.new,
        'json'      => Package::InfoJSON.new,
        'pretty'    => Package::InfoPretty.new,
        'table'     => Package::InfoTable.new
      }

      def self.get_package(package_key, options = {})
        results  = API.get_package(package_key, options)
        if valid_response?(results, "Didnt find any package with product_key: `#{package_key}`")
          show_results(@@output_formats, results.data, options, results.data['paging'])
        end
      end
    end
  end
end
