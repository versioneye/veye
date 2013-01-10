module Veye
    class Service
        def self.ping(n = 1)
            public_api = API::Resource.new
            api_respond =  "no idea"
            public_api.resource['/ping.json'].get do |response, request, result, &block|
                api_respond = API::JSONResponse.new(request, result, response)
            end

            return api_respond
        end
    end
end  
