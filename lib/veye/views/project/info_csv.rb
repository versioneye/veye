require_relative '../base_csv.rb'

module Veye
  module Project
    class InfoCSV < BaseCSV
      def initialize
        headers = "nr,name,project_id,public,period,source,dep_number,out_number,created_at"
        super(headers)
      end
      def format(results)
        return nil if results.nil?
        results = [results] if results.is_a? Hash
        
        results.each_with_index do |result, index|
          #BUG: API returns raw mongoID value as id when fetching a list of projects
          if result['id'].is_a?(Hash)
            result['id'] = result['id'].values.first 
          end


          printf("%d,%s,%s,%s,%s,%s,%s,%s,%s\n",
                index + 1,
                result['name'],
                result['id'],
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

