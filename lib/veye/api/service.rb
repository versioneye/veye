module Veye
  module API
    module Service
      RESOURCE_PATH = "/services"

      def self.ping(n = 1)
        public_api = Resource.new "#{RESOURCE_PATH}/ping"
        public_api.resource.get do |response, request, result, &block|
          JSONResponse.new(request, result, response)
        end
      end
    end
  end
end
