require_relative '../base_json.rb'

module Veye
  module Package
    class VersionsJSON < BaseJSON
      def format(results, n = 10, from = 0)
        @results[:results]    = results
        @results[:pagination] = {
          n: n,
          from: from
        }
      end
    end
  end
end
