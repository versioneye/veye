require_relative '../base_json.rb'

module Veye
  module Github
    class InfoJSON < BaseJSON
      def format(results)
        @results[:repo] = results['repo']

        if results.has_key?('imported_projects')
          @results[:projects] = results['imported_projects']
        end
      end
    end
  end
end
