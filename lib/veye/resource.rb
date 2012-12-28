module Veye
	module API
  	  require 'rest_client'

  	  CONFIGS = {:url => "https://www.versioneye.com/api/v1"}
  	  class Resource
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
