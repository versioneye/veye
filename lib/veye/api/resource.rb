require 'rest_client'
require_relative 'base_resource.rb'


#for ssl keys:
#openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -nodes
module Veye
  module API
    class Resource < BaseResource
      def initialize(path = nil)
        super(path)
        ssl_path = File.expand_path($global_options[:ssl_path])
        @resource = RestClient::Resource.new(@full_path)
      end
    end
  end
end
