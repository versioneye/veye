module Veye
  module API
    # Package API wrappers
    module Package
      RESOURCE_PATH = '/products'

      def supported_languages
        Set.new %w( Clojure Java Javascript Node.JS PHP Python Ruby R )
      end

      def self.encode_prod_key(prod_key)
        prod_key.to_s.gsub(/\//, ':').gsub(/\./, '~')
      end

      def self.encode_language(lang)
        lang.to_s.gsub(/\./, '').downcase
      end

      # returns package information
      def self.get_package(prod_key, language)
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)
        product_api = Resource.new "RESOURCE_PATH/#{lang}/#{safe_prod_key}"
        product_api.resource.get do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.search(search_term, language = nil, group_id = nil, page = '1')
        search_api = Resource.new "#{RESOURCE_PATH}/search/#{search_term}"

        search_params = { q: search_term.to_s }
        search_params[:lang] = encode_language(language) unless language.nil?
        search_params[:g] = group_id unless group_id.nil?
        if page.nil?
          search_params[:page] = '1'
        else
          search_params[:page] = page.to_s
        end

        request_params = { params: search_params }
        search_api.resource.get(request_params) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.get_follow_status(api_key, prod_key, language)
        product_api = Resource.new(RESOURCE_PATH)
        qparams = { params: { api_key: api_key } }
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)

        path = "#{lang}/#{safe_prod_key}/follow.json"
        product_api.resource[path].get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

      def self.follow(api_key, prod_key, language)
        api = Resource.new(RESOURCE_PATH)
        qparams = { api_key: api_key }
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)

        path = "/#{lang}/#{safe_prod_key}/follow.json"
        api.resource[path].post(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.unfollow(api_key, prod_key, language)
        api = Resource.new(RESOURCE_PATH)
        qparams = { params: { api_key: api_key } }
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)

        path = "/#{lang}/#{safe_prod_key}/follow.json"
        api.resource[path].delete(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.get_references(prod_key, language, page = nil)
        api = Resource.new(RESOURCE_PATH)
        lang = encode_language(language).capitalize # endpoint bug
        safe_prod_key = encode_prod_key(prod_key)

        api_path = "/#{lang}/#{safe_prod_key}/references"
        page_nr = page.to_s unless page.nil?
        page_nr ||= 1
        qparams = { params: { page: page_nr } }
        api.resource[api_path].get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end
    end
  end
end
