require_relative '../base_json.rb'

module Veye
  module User
    class FavoriteJSON < BaseJSON
      def format(results)
        return if results.nil?
        @results[:favorites] = results['favorites']
      end
    end
  end
end

