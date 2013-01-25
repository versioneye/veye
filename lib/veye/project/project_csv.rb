module Veye
  module Project
    class ProjectCSV
      def before
        printf("nr,name,project_key,private,period,source,dep_number,out_number,created_at\n")
      end
      def after; end

      def format(results)
        results = [results] if results.is_a? Hash

        results.each_with_index do |result, index|
          printf("%d,%s,%s,%s,%s,%s,%s,%s,%s\n",
                index + 1,
                result['name'],
                result['project_key'],
                result['private'],
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

