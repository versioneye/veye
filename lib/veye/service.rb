module Veye
    class Service
        def self.ping(n = 1)
            public_api = Veye::API::Resource.new
            status = "no idea"
            public_api.resource['/ping.json'].get do |response, request, result, &block|
                if result.code.to_i == 200
                    status =  "up".foreground(:green)
                else
                      status =  "down".foreground(:red)
                  $stderr.puts "#{results.code.foreground(:red)} - #{request.url}"
                end
            end
            puts "VersionEye is: #{status}"
        end
    end
end  
