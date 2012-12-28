module Veye
	module JSONRequest
		require 'json'

		def getJSON(path, params = nil, configs = nil)
      request_params = {}
      request_configs = {:content_type  => :json,
                         :accept        => :json}

      request_params.merge!(params) unless params.nil?
      request_configs.merge!(configs) unless configs.nil?
      request_configs[:params] = request_params unless request_params.empty?
			response = nil
			begin
			 response = @resource[path].get request_configs
			 response = JSON.parse(response)
			rescue => e
			   $stderr.puts e.response
			end
			response
		end
	end

	module API
  	  require 'rest_client'

  	  CONFIGS = {:url => "https://www.versioneye.com/api/v1"}
  	  class Resource
  		include JSONRequest
    	attr_reader :resource
    	def initialize(path = nil)
          @full_path = CONFIGS[:url]
          @full_path = "#{@full_path}#{path}" unless path.nil?

      	  @resource = RestClient::Resource.new(@full_path)
    	end
  	  end

  	  class PrivateResource
    	attr_reader :resource
    	def initialize(username, password)
      	  @resource = RestClient::Resource.new(CONFIGS[:url], username, password)
    	end
  	  end
	end
end
