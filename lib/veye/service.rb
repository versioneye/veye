module Veye
  class Service
    RESOURCE_PATH = "/services"
    def self.ping(n = 1)
      public_api = API::Resource.new RESOURCE_PATH
      api_response =  "no idea"
      public_api.resource['/ping'].get do |response, request, result, &block|
        api_response = API::JSONResponse.new(request, result, response)
      end
      show_result(api_response)
      return api_response
    end

    def self.show_result(result)
      if result.success
        puts "#{result.data['message']}".color(:green)
     else
       printf(
         "VersionEye didnt recognized secret word.Answered %s, %s\n",
         result.code.to_s.color(:red),
         "#{result.message}".color(:yellow)
       )
     end
    end
  end
end
