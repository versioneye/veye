module Veye
	module JSONRequest
		require 'json'

		def getJSON(path)
			response = nil
			begin
			 response = @resource[path].get :content_type  => "json", 
			 	 							:accept 		=> "json"
			 response = JSON.parse(response)
			rescue => e
			  error(e.response)
			end
			response
		end
	end

	module API
  	  require 'rest_client'

  	  CONFIGS = {:path => "https://www.versioneye.com/api/v1"}
  	  class Resource 
  		include JSONRequest
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
