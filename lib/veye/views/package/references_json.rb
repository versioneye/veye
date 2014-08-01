require_relative '../base_json.rb'

module Veye
  module Package
    class ReferencesJSON < BaseJSON
      def format(results)
        @results[:results] = results['results']
      end
    end
  end
end
