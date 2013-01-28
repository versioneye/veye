module Veye
  module Package
    class Follow
   
      def self.get_follow_status(prod_key, api_key)
        product_api = API::Resource.new(RESOURCE_PATH)
        response_data = nil
        qparams = {:params => {:api_key => api_key}}
        safe_prod_key = Package.encode_prod_key(prod_key)
        product_api.resource[
          "/#{safe_prod_key}/follow.json"].get(qparams) do |response, request, result|
          
          response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
      end

      def self.follow(prod_key, api_key)
        product_api = API::Resource.new(RESOURCE_PATH)
        response_data = nil
        qparams = {:api_key => api_key}
        safe_prod_key = Package.encode_prod_key(prod_key)

        product_api.resource[
          "/#{safe_prod_key}/follow.json"].post(qparams) do |response, request, result|
          
          response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
      end

      def self.unfollow(prod_key, api_key)
        product_api = API::Resource.new(RESOURCE_PATH)
        response_data = nil
        qparams = {:params => {:api_key => api_key}}
        safe_prod_key = Package.encode_prod_key(prod_key)

        product_api.resource[
          "/#{safe_prod_key}/follow.json"].delete(qparams) do |response, request, result|
          
          response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
      end
    end
  end
end
