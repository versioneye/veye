require_relative '../base_csv.rb'

module Veye
  module Package
    class ReferencesCSV < BaseCSV
      def initialize
        headers = "nr,name,language,prod_key,prod_type,version"
        super(headers)
      end

      def format(response)
        items = response['results']
        return if items.nil?

        items.each_with_index do |result, index|
          printf("%d,%s,%s,%s,%s,%s\n",
                index + 1,
                result["name"],
                result["language"],
                result["prod_key"],
                result["prod_type"],
                result["version"])
        end
      end
    end
  end
end

