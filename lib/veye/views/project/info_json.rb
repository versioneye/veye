require_relative '../base_json.rb'

module Veye
  module Project
    class InfoJSON < BaseJSON
      def format(results)
        @results[:projects] = results
      end
    end
  end
end

