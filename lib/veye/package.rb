require_relative 'package/info.rb'
require_relative 'package/search.rb'
require_relative 'package/follow.rb'
require_relative 'package/references.rb'

# -- define module constants here
module Veye
  module Package
    RESOURCE_PATH = "/products"

    def supported_languages
      Set.new ["Clojure", "Java", "Javascript", "Node.JS", "PHP", "Python", "Ruby", "R"]
    end

    def self.encode_prod_key(prod_key)
      prod_key = prod_key.to_s
      prod_key.gsub(/\//, ":").gsub(/\./, "~")
    end

    def self.encode_language(lang)
      lang.gsub(/\./, "").downcase
    end
  end
end
