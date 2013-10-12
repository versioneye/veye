require_relative '../base_csv.rb'

module Veye
  module Github
    class ListCSV < BaseCSV
      def initialize
        headers = "nr,fullname,language,owner_login,owner_type,private,fork,branches,description"
        super(headers)
      end

      def format(results)
        results['repos'].each_with_index do |result, index|
          printf("%d,%s,%s,%s,%s,%s,%s,%s,%s\n",
                index + 1,
                result['fullname'],
                result['language'],
                result['owner_login'],
                result['owner_type'],
                result['private'],
                result['fork'],
                result['branches'].join('|'),
                result['description']
                )
        end
      end
    end
  end
end
