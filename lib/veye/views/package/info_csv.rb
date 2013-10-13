require_relative '../base_csv.rb'

module Veye
  module Package
    class InfoCSV < BaseCSV
      def initialize
        headers = "name,version,language,prod_key,licence,prod_type,description,link"
        super(headers)
      end
      def format(result)
        printf("%s,%s,%s,%s,%s,%s,%s,%s\n",
              result["name"], result["version"], result["language"],
              result["prod_key"], result["license"], result["prod_type"],
              result["link"], result["description"])
      end
    end
  end
end

