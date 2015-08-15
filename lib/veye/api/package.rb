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
      def self.get_package(prod_key, language)
        product_api = Resource.new RESOURCE_PATH
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)

        product_api.resource["/#{lang}/#{safe_prod_key}"].get do |response, request, result, &block|
          JSONResponse.new(request, result, response)
        end
      end

      def self.search(search_term, language = nil, group_id = nil, page = "1")
        search_api = Resource.new "#{RESOURCE_PATH}/search/#{search_term}"

        search_params = {:q => search_term.to_s}
        search_params[:lang] = encode_language(language) unless language.nil?
        search_params[:g] = group_id unless group_id.nil?
        unless page.nil?
          search_params[:page] = page.to_s
        else
          search_params[:page] = "1"
        end

        request_params = {:params => search_params}
        search_api.resource.get(request_params) do |response, request, result, &block|
          JSONResponse.new(request, result, response)
        end
      end

    end
  end
end
