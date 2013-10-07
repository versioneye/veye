require_relative 'info_csv.rb'
require_relative 'info_json.rb'
require_relative 'info_pretty.rb'
require_relative 'info_table.rb'

module Veye
  module Package    
    class Info
      extend FormatHelpers

      @@output_formats = {
        'csv'       => InfoCSV.new,
        'json'      => InfoJSON.new,
        'pretty'    => InfoPretty.new,
        'table'     => InfoTable.new
      }

      def self.search(package_key)
        product_api = API::Resource.new(RESOURCE_PATH)
        tokens = package_key.to_s.split('/')
        lang = Package.encode_language(tokens.first)
        safe_prod_key = Package.encode_prod_key(tokens.drop(1).join("/"))
        
        if lang.nil? or safe_prod_key.nil?
          msg =  %Q[
            You missed language or product key. 
            Example: clojure/ztellman/aleph, which as required structure <prog lang>/<product_code>
          ]
          error_msg = sprrintf("%s. \n%s", 
                               "Error: Malformed key.".foreground(:red),
                              msg)
          exit_now!(error_msg)
        end

        request_response = nil 
        product_api.resource["/#{lang}/#{safe_prod_key}"].get do |response, request, result, &block|
          request_response = API::JSONResponse.new(request, result, response)
        end
        return request_response
      end

      def self.format(results, format = 'pretty')
        self.supported_format?(@@output_formats, format)

        formatter = @@output_formats[format]
        formatter.before
        formatter.format(results)
        formatter.after
      end
    end

  end
end
