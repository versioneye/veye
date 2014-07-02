require_relative '../base_executor.rb'

module Veye
  module Package
    class Follow < BaseExecutor
      def self.parse_prod_key(prod_key)
        tokens = prod_key.to_s.split('/')
        lang = Package.encode_language(tokens.first)
        safe_prod_key = Package.encode_prod_key(tokens.drop(1).join("/"))
        [lang, safe_prod_key]
      end

      def self.get_follow_status(prod_key, api_key)
        product_api = API::Resource.new(RESOURCE_PATH)
        results = nil
        qparams = {:params => {:api_key => api_key}}
        lang, safe_prod_key = parse_prod_key(prod_key)
        product_api.resource[
          "#{lang}/#{safe_prod_key}/follow.json"].get(qparams) do |response, request, result|

          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Didnt get any response.")
        show_result(results)
        results
      end

      def self.follow(prod_key, api_key)
        product_api = API::Resource.new(RESOURCE_PATH)
        results = nil
        qparams = {:api_key => api_key}
        lang, safe_prod_key = parse_prod_key(prod_key)
        product_api.resource[
          "/#{lang}/#{safe_prod_key}/follow.json"].post(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end
        catch_request_error(results, "Cant follow.")
        show_result(results)
        results
      end

      def self.unfollow(prod_key, api_key)
        product_api = API::Resource.new(RESOURCE_PATH)
        results = nil
        qparams = {:params => {:api_key => api_key}}
        lang, safe_prod_key = parse_prod_key(prod_key)
        product_api.resource[
          "/#{lang}/#{safe_prod_key}/follow.json"].delete(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Cant unfollow.")
        show_result(results)
        results
      end

      def self.show_result(response)
        result = response.data
        return if result.nil?
        printf "Following `#{result['prod_key']}`: #{result['follows']}\n".color(:green)
      end
    end
  end
end
