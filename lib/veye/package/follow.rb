require_relative '../base_executor.rb'

module Veye
  module Package
    module API
      def self.parse_prod_key(prod_key)
        tokens = prod_key.to_s.split('/')
        lang = Package.encode_language(tokens.first)
        safe_prod_key = Package.encode_prod_key(tokens.drop(1).join("/"))
        [lang, safe_prod_key]
      end

      def self.get_follow_status(prod_key, api_key)
        product_api = Veye::API::Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}
        lang, safe_prod_key = API.parse_prod_key(prod_key)

        path = "#{lang}/#{safe_prod_key}/follow.json"
        product_api.resource[path].get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

      def self.follow(prod_key, api_key)
        product_api = Veye::API::Resource.new(RESOURCE_PATH)
        qparams = {:api_key => api_key}
        lang, safe_prod_key = API.parse_prod_key(prod_key)
        path = "/#{lang}/#{safe_prod_key}/follow.json"
        product_api.resource[path].post(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

      def self.unfollow(prod_key, api_key)
        product_api = Veye::API::Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}
        lang, safe_prod_key = API.parse_prod_key(prod_key)

        path = "/#{lang}/#{safe_prod_key}/follow.json"
        product_api.resource[path].delete(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end
    end

    class Follow < BaseExecutor
      def self.show_result(response)
        result = response.data
        return if result.nil?
        printf "Following `#{result['prod_key']}`: #{result['follows']}\n".color(:green)
      end

      def self.get_follow_status(prod_key, api_key)
        results = API.get_follow_status(prod_key, api_key)
        if valid_response?(results, "Didnt get any response.")
          show_result(results)
        end
      end

      def self.follow(prod_key, api_key)
        results = API.follow(prod_key, api_key)
        if valid_response?(results, "Cant follow.")
          show_result(results)
        end
      end

      def self.unfollow(prod_key, api_key)
        results = API.unfollow(prod_key, api_key)
        if valid_response?(results, "Cant unfollow.")
          show_result(results)
        end
      end
    end
  end
end
