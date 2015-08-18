module Veye
  module API
    # API wrappers for User api
    module User
      RESOURCE_PATH = '/me'

      def self.get_profile(api_key)
        user_api = Resource.new RESOURCE_PATH
        qparams = { params: { api_key: api_key } }

        user_api.resource.get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end

      def self.get_favorites(api_key, page = 1)
        fav_api = Resource.new "#{RESOURCE_PATH}/favorites"
        page ||= 1
        qparams = {
          params: {
            api_key: api_key,
            page: page
          }
        }

        fav_api.resource.get(qparams) do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end
    end
  end
end
