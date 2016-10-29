require 'rest-client'
require_relative 'base_resource.rb'

module Veye
  module API
    class Resource < BaseResource
      def initialize(path = nil)
        super(path)
        #hardcoded values come from api.rb file
        timeout_val = safe_to_i( $global_options[:timeout] )
        timeout = ( timeout_val > 0 ) ? timeout_val : 90 # dont allow 0
        open_timeout_val = safe_to_i( $global_options[:open_timeout] )
        open_timeout = ( open_timeout_val > 0 ) ? open_timeout_val : 10 #dont allow 0

        @resource = RestClient::Resource.new(
          @full_path,
          timeout: timeout,
          open_timeout: open_timeout,
        )
      end

      def safe_to_i(val)
        val.to_i
      rescue
        return 0
      end

    end
  end
end
