module Veye
  module Project
    class ProjectDependencyCSV
      def before 
        printf("nr,name,prod_key,outdated,latest,current\n",nil)
      end
      def after; end

      def format(results)
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|
            printf("%d,%s,%s,%s,%s,%s\n",
                   index + 1, 
                   result["name"],
                   result["prod_key"],
                   result["outdated"],
                   result["version_current"],
                   result["version_requested"],
                  )
        end
      end
    end
  end
end
