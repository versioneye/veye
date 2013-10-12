require_relative '../base_json.rb'

module Veye
  module Github
    class InfoJSON < BaseJSON
      def format(results)
        @results[:repo] = results['repo']
      end
    end
  end
end
