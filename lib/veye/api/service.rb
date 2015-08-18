module Veye
  module API
    # API wrappers for Service endpoint
    module Service
      RESOURCE_PATH = '/services'

      def self.ping
        public_api = Resource.new "#{RESOURCE_PATH}/ping"
        public_api.resource.get do |response, request, result|
          JSONResponse.new(request, result, response)
        end
      end
    end
  end
end
