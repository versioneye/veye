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

        unless port.to_s.empty?
            resource_url = "#{protocol}://#{server}:#{port}/#{path}"
        else
            resource_url = "#{protocol}://#{server}/#{path}"
        end

        return resource_url
      end
    end

  end
end
