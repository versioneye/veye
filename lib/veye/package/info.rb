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
        request_response = {
          :params => {:q => package_key},
          :results => []
        }
        product_api = Veye::API::Resource.new(RESOURCE_PATH)

        #clean package key 
        package_key = package_key.gsub(/\//, "--").gsub(/\./, "~")
        product_api.resource["/#{package_key}.json"].get do |response, request, result, &block|
            if result.code.to_i == 200
                request_response[:results] = JSON.parse(response) 
            end
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
