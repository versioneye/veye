require 'rest-client'
require_relative 'base_resource.rb'

module Veye
  module API
    class Resource < BaseResource
      def initialize(path = nil)
        super(path)
        timeout_val = $global_options[:timeout].to_i
        timeout = timeout_val if timeout_val > 0
        timeout ||= 90
        open_timeout = $global_options[:open_timeout].to_i || 10

        @resource = RestClient::Resource.new(
          @full_path,
          timeout: timeout,
          open_timeout: open_timeout,
        )
      end
    end
  end
end
