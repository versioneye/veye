require_relative 'package/info.rb'
require_relative 'package/search.rb'
require_relative 'package/follow.rb'

# -- define module constants here
module Veye
  module Package
    RESOURCE_PATH = "/products"

    def self.encode_prod_key(prod_key)
      prod_key = prod_key.to_s
      encoded_key = prod_key.gsub(/\//, "--").gsub(/\./, "~")
      
      return encoded_key
    end
  end
end
