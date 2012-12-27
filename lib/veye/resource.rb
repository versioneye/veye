module Veye
	module Api
  	  require 'rest_client'
      require 'json'

  	  CONFIGS = {:path => "https://www.versioneye.com/api/v1"}
  	  class Resource
    	attr_reader :resource
    	def initialize   
      	  @resource = RestClient::Resource.new(CONFIGS[:path])
    	end
  	  end

  	  class PrivateResource
    	attr_reader :resource
    	def initialize(username, password)
      	  @resource = RestClient::Resource.new(CONFIGS[:path], username, password)
    	end
  	  end
	end
end
