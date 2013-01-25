module Veye
  class Service
    RESOURCE_PATH = "/services"
    def self.ping(n = 1)
      public_api = API::Resource.new RESOURCE_PATH
      api_respond =  "no idea"
      public_api.resource['/ping.json'].get do |response, request, result, &block|
        api_respond = API::JSONResponse.new(request, result, response)
      end

      return api_respond
    end
  end
end  
