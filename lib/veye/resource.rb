require 'rest_client'

module Veye
	module API
      class  BaseResource
        attr_reader :resource
        
        def initialize(path = nil)
          @full_path = $global_options[:url]
          @full_path = "#{@full_path}#{path}" unless path.nil?
        end
      end

  	  class Resource < BaseResource
        def initialize(path = nil)
          super(path)  
          @resource = RestClient::Resource.new(@full_path)
        end
  	  end

  	  class PrivateResource < BaseResource
    	  def initialize(username, password)
            super(path)
            @resource = RestClient::Resource.new(CONFIGS[:url], username, password)
    	  end
  	  end
	end
end
