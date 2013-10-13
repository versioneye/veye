require_relative '../base_json.rb'

module Veye
  module Project
    class LicenceJSON < BaseJSON
      def format(results)
        @results[:licences] = results["licenses"]
      end
    end
  end
end
