require 'rest-client'
require_relative 'base_resource.rb'

#for ssl keys:
#openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -nodes
# TODO: clean up after client SSL issue is fixed
module Veye
  module API
    class Resource < BaseResource
      def initialize(path = nil)
        super(path)
        #ssl_path  = File.expand_path($global_options[:ssl_path])
        #cert_path =  ssl_path + "/veye_cert.pem"
        #key_path  = ssl_path + "/veye_key.pem"
        timeout   = $global_options[:timeout].to_i || 90
        open_timeout = $global_options[:open_timeout].to_i || 10

        #temporary workaround - RestClient didnt work with generated certs after update
        @resource = RestClient::Resource.new(
          @full_path,
          timeout: timeout,
          open_timeout: open_timeout,
          #ssl_client_cert: OpenSSL::X509::Certificate.new(File.read(cert_path)),
          #ssl_client_key: OpenSSL::PKey::RSA.new(File.read(key_path)),
          #ssl_ca_file: "ca_certificate.pem",
          verify_ssl: false
        )
      end
    end
  end
end
