require_relative '../base_json.rb'

module Veye
  module Github
    class SearchJSON < BaseJSON
      def format(results)
        @results[:results] = results['results']
      end
    end
  end
end

