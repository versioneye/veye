require_relative '../base_csv.rb'

module Veye
  module Github
    class SearchCSV < BaseCSV
      def initialize
        columns = %w[nr,name,language,owner_name,owner_type,private,fork,watchers,forks,git_url]
        super(columns)
      end

      def format(results)
        return if results.nil?

        results['results'].each_with_index do |result, index|
          print_row(result, index)
        end
      end

      def print_row(result, index)
        printf("%d,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
                index + 1,
                result['name'],
                result['language'],
                result['owner_name'],
                result['owner_type'],
                result['private'],
                result['fork'],
                result['watchers'],
                result['forks'],
                result['git_url']
              )
      end
    end
  end
end

