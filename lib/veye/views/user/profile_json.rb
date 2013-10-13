require_relative '../base_json.rb'

module Veye
  module User
    class ProfileJSON < BaseJSON
      def format(results)
        @results[:profile] = results
      end
    end
  end
end

