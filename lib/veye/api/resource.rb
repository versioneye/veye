require 'rest_client'
require_relative 'base_resource.rb'

module Veye
  module API
    class Resource < BaseResource
      def initialize(path = nil)
        super(path)
        @resource = RestClient::Resource.new(@full_path)
      end
    end
  end
end
