module Veye
  module API
    # extends child classes with URL and API helpers
    class BaseResource
      attr_reader :resource, :full_path

      def initialize(path = nil)
        @full_path = "#{$global_options[:url]}#{path}"
      end

      def self.build_url(global_options)
        resource_url = nil
        protocol = global_options[:protocol]
        server = global_options[:server]
        port = global_options.fetch(:port, '')
        path = global_options[:path]

        if port.to_s.empty?
          resource_url = "#{protocol}://#{server}/#{path}"
        else
          resource_url = "#{protocol}://#{server}:#{port}/#{path}"
        end

        resource_url
      end
    end
  end
end
