require 'rest_client'

module Veye
	module API
      class  BaseResource
        attr_reader :resource, :full_path 
        def initialize(path = nil)
          @full_path = $global_options[:url]
          @full_path = "#{@full_path}#{path}" unless path.nil?
        end

        def self.build_url(global_options)
          resource_url = nil
          protocol = global_options[:protocol]
          server = global_options[:server]
          port = global_options.fetch(:port, "")
          path = global_options[:path]

          unless port.empty?
              resource_url = "#{protocol}://#{server}:#{port}/#{path}"
          else
              resource_url = "#{protocol}://#{server}/#{path}"
          end

          return resource_url
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
