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
      def self.get_package(api_key, prod_key, language)
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)
        qparams = {}
        qparams[:api_key] = api_key if api_key.to_s.size > 0
        product_api = Resource.new "#{RESOURCE_PATH}/#{lang}/#{safe_prod_key}"
        product_api.resource.get({params: qparams}) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.search(api_key, search_term, language = nil, group_id = nil, page = '1')
        search_api = Resource.new "#{RESOURCE_PATH}/search/#{search_term}"

        qparams = { q: search_term.to_s }
        qparams[:lang] = encode_language(language) unless language.nil?
        qparams[:g] = group_id unless group_id.nil?
        if page.nil?
          qparams[:page] = '1'
        else
          qparams[:page] = page.to_s
        end

        qparams[:api_key] = api_key if api_key.to_s.size > 0
        search_api.resource.get({params: qparams}) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.get_follow_status(api_key, prod_key, language)
        product_api = Resource.new(RESOURCE_PATH)
        qparams = {api_key: api_key}
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)
        path = "#{lang}/#{safe_prod_key}/follow.json"
        product_api.resource[path].get({params: qparams}) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

      def self.follow(api_key, prod_key, language)
        api = Resource.new(RESOURCE_PATH)
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)

        path = "/#{lang}/#{safe_prod_key}/follow.json?api_key=#{api_key}"
        api.resource[path].post({}) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.unfollow(api_key, prod_key, language)
        api = Resource.new(RESOURCE_PATH)
        qparams = {api_key: api_key}
        lang = encode_language(language)
        safe_prod_key = encode_prod_key(prod_key)

        path = "/#{lang}/#{safe_prod_key}/follow.json"
        api.resource[path].delete({params: qparams}) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.get_references(api_key, prod_key, language, page = nil)
        api = Resource.new(RESOURCE_PATH)
        lang = encode_language(language).capitalize # endpoint bug
        safe_prod_key = encode_prod_key(prod_key)
  
        api_path = "/#{lang}/#{safe_prod_key}/references"
        page_nr = page.to_s unless page.nil?
        page_nr ||= 1
        
        qparams = {page: page_nr}
        qparams[:api_key] = api_key if api_key.to_s.size > 0 
        api.resource[api_path].get({params: qparams}) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end
    end
  end
end
