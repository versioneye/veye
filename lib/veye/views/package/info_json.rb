require_relative '../base_json.rb'

module Veye
  module Package
    class InfoJSON < BaseJSON
      def format(results)
        @results[:package] = results
      end
    end
  end
end

