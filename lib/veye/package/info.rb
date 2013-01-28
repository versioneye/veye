require_relative 'info_csv.rb'
require_relative 'info_json.rb'
require_relative 'info_pretty.rb'
require_relative 'info_table.rb'

module Veye
  module Package
    
    class Info
      @@output_formats = {
        'csv'       => InfoCSV.new,
        'json'      => InfoJSON.new,
        'pretty'    => InfoPretty.new,
        'table'     => InfoTable.new
      }

      def self.search(package_key)
        product_api = API::Resource.new(RESOURCE_PATH)
        safe_prod_key = Package.encode_prod_key(package_key)
        request_response = nil 
        product_api.resource["/#{safe_prod_key}.json"].get do |response, request, result, &block|
           
          request_response = API::JSONResponse.new(request, result, response)
        end
        return request_response
      end

      def self.format(results, format = 'pretty')
        formatter = @@output_formats[format]
        formatter.before
        formatter.format(results)
        formatter.after
      end
    end

  end
end
