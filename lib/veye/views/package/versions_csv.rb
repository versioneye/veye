require_relative '../base_csv.rb'

module Veye
  module Package
    class VersionsCSV < BaseCSV
      def initialize
        headers = "nr,version,language,prod_key,prod_type,released_at"
        super(headers)
      end

      def format(results, n = 10, from = 0)
        prod_dt = results

        results['versions'].to_a.each_with_index do |ver, i|
          printf(
            "%s,%s,%s,%s,%s,%s\n",
             (from + i + 1), ver['version'], prod_dt['language'],
             prod_dt['prod_key'], prod_dt['prod_type'], ver['released_at']
          )
        end
      end
    end
  end
end
