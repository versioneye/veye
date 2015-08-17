module Veye
  module API
    module User
      RESOURCE_PATH = "/me"

      def self.get_profile(api_key, options)
        user_api = Resource.new RESOURCE_PATH
        qparams = {:params => {:api_key => api_key}}

        user_api.resource.get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.get_favorites(api_key, options)
        user_api = Resource.new RESOURCE_PATH
        page = options[:page] || 1
        qparams = {
          :params => {
            :api_key => api_key,
            :page => page
          }
        }

        user_api.resource['/favorites'].get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end
    end
  end
end
