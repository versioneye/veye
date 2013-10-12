require_relative '../base_json.rb'

module Veye
  module Github
    class ListJSON < BaseJSON
      def initialize
        super()
      end
      def format(results)
        results = results.shift if results.is_a? Array
        @results[:repos] = results['repos']
      end
    end
  end
end

