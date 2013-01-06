require_relative 'info_format/csv.rb'
require_relative 'info_format/json.rb'
require_relative 'info_format/pretty.rb'
require_relative 'info_format/table.rb'

module Veye
  module Package
    class Info
      @@output_formats = {
        'csv'       => Veye::InfoFormat::CSV.new,
        'json'      => Veye::InfoFormat::JSON.new,
        'pretty'    => Veye::InfoFormat::Pretty.new,
        'table'     => Veye::InfoFormat::Table.new
      }

      def self.search(package_key)
        request_response = {
          params: {:q => package_key},
          results: []
        }
        product_api = Veye::API::Resource.new("/products")

        #clean package key 
        package_key = package_key.gsub(/\//, "--").gsub(/\./, "~")
        product_api.resource["/#{package_key}.json"].get do |response, request, result, &block|
            if result.code.to_i == 200
                request_response[:results] = JSON.parse(response) 
            end
        end

        return request_response
      end

      def self.format(result, format = 'pretty')
          formatter = @@output_formats[format]
          formatter.before
          formatter.format(result)
          formatter.after
      end
    end

  end
end
