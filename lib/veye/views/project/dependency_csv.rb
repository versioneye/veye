require_relative '../base_csv.rb'

module Veye
  module Project
    class DependencyCSV < BaseCSV
      def initialize
        headings = "nr,name,prod_key,outdated,version_current,version_requested,stable,license"
        super(headings)
      end

      def format(results)
        return nil if results.nil?
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|
            printf("%d,%s,%s,%s,%s,%s,%s,%s\n",
                   index + 1,
                   result['name'],
                   result['prod_key'],
                   result['outdated'],
                   result['version_current'],
                   result['version_requested'],
                   result['stable'],
                   result['license']
                 )
        end
      end
    end
  end
end
