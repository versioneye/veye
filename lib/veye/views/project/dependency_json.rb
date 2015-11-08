require_relative '../base_json.rb'

module Veye
  module Project
    class DependencyJSON < BaseJSON
      def format(results, filename = nil)
        if filename.nil?
          @results[:repo] = results['repo']
        else
          @results[filename] = results
        end
      end
    end
  end
end
