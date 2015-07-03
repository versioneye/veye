module Veye

  module API
    RESOURCE_PATH = "/services"
    def self.ping(n = 1)
      public_api = API::Resource.new RESOURCE_PATH
      api_response =  nil
      public_api.resource['/ping'].get do |response, request, result, &block|
        api_response = API::JSONResponse.new(request, result, response)
      end
      return api_response
    end
  end

  #-- CLI wrappers for API
  class Service
    def self.ping(n = 1)
      show_result(Veye::API.ping)
    end

    def self.show_result(result)
      if result.nil?
        puts "Request failure".color(:red)
      elsif result.success
        puts "#{result.data['message']}".color(:green)
      else
        printf(
          "VersionEye didnt recognized secret word.Answered %s, %s\n",
          result.code.to_s.color(:red),
          result.message.to_s.color(:yellow)
        )
      end
    end
  end
end
