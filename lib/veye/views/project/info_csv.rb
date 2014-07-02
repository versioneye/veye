require_relative '../base_csv.rb'

module Veye
  module Project
    class InfoCSV < BaseCSV
      def initialize
        headers = "nr,name,project_key,public,period,source,dep_number,out_number,created_at"
        super(headers)
      end
      def format(results)
        return nil if results.nil?
        results = [results] if results.is_a? Hash

        results.each_with_index do |result, index|
          printf("%d,%s,%s,%s,%s,%s,%s,%s,%s\n",
                index + 1,
                result['name'],
                result['project_key'],
                result['public'],
                result['period'],
                result['source'],
                result['dep_number'],
                result['out_number'],
                result['created_at'])
        end
      end
    end
  end
end

