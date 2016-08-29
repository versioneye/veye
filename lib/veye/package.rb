require_relative 'package/info.rb'
require_relative 'package/search.rb'
require_relative 'package/follow.rb'
require_relative 'package/references.rb'
require_relative 'package/versions.rb'

# -- define module constants here
module Veye
  module Package
    RESOURCE_PATH = "/products"

    def supported_languages
      Set.new ["Clojure", "Java", "Javascript", "Node.JS", "PHP", "Python", "Ruby", "R"]
    end

    #TODO remove it
    def self.parse_key(package_key)
      tokens = package_key.to_s.split('/')
      lang = tokens.first
      prod_key = tokens.drop(1).join("/")

      if lang.nil? or prod_key.nil?
        msg =  %Q[
          You missed language or product key.
          Example: clojure/ztellman/aleph, as structured <prog lang>/<product_code>
        ]
        printf("%s. \n%s", "Error: Malformed key.".color(:red), msg)
        exit
      end

      [prod_key, lang]
    end
  end
end
