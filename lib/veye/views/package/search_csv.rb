require_relative '../base_csv.rb'

module Veye
  module Package
    class SearchCSV < BaseCSV
      def initialize
        headers = "nr,name,version,prod_key,language,group_id"
        super(headers)
      end

      def format(results)
        items = results['results']
        return if items.nil?

        items.each_with_index do |result, index|
          printf("%d,%s,%s,%s,%s,%s\n",
                  index + 1,
                  result["name"],
                  result["version"],
                  result["prod_key"],
                  result["language"],
                  result["group_id"])
        end
      end
    end
  end
end
