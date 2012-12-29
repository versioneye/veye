module Veye
  class Package
    def self.info(package_key)
      product_api = Veye::API::Resource.new("/products")
      
      puts "Asking information about: #{package_key.foreground(:green)}"
      package_key = package_key.gsub(/\//, "--").gsub(/\./, "~")
      product_api.resource["/#{package_key}.json"].get do |response, request, result, &block|
          if result.code.to_i == 200
            ap JSON.parse(response)
          else
            puts "Didnt found package key: `#{package_key.foreground(:yellow)}`"
            puts "Code: #{result.code.foreground(:red)}"
            puts request.url
          end
      end

    end
  end
end
