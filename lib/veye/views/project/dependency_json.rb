require_relative '../base_json.rb'

module Veye
  module Project
    class DependencyJSON < BaseJSON
      def format(results)
        @results[:repo] = results['repo']
      end
    end
  end
end
