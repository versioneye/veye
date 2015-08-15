module Veye
  module API
    module Package
      RESOURCE_PATH = "/products"

      def supported_languages
        Set.new ["Clojure", "Java", "Javascript", "Node.JS", "PHP", "Python", "Ruby", "R"]
      end

      def self.encode_prod_key(prod_key)
        prod_key.to_s.gsub(/\//, ":").gsub(/\./, "~")
      end

      def self.encode_language(lang)
        lang.to_s.gsub(/\./, "").downcase
      end

      #return package information
      def self.get_package(package_key, options = {})
        product_api = Resource.new(RESOURCE_PATH)
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
          results = JSONResponse.new(request, result, response)
        end
        return results
      end
 
    end
  end
end
