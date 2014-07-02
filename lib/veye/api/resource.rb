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
        timeout = $global_options[:timeout].to_i || 90
        open_timeout = $global_options[:open_timeout].to_i || 10

        @resource = RestClient::Resource.new(@full_path,
                                             timeout: timeout,
                                             open_timeout: open_timeout)
      end
    end
  end
end
