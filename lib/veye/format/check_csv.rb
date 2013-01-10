module Veye
  module Format
    class CheckCSV
        def before 
            printf("nr,name,prod_key,outdated,latest,current,updated\n",nil)
        end
        def after; end

        def format(results)
            results = [results] if results.is_a?(Hash)

            results.each_with_index do |result, index|
                printf("%d,%s,%s,%s,%s,%s,%s\n",
                       index, 
                       result["name"],
                       result["prod_key"],
                       result["outdated"],
                       result["version_current"],
                       result["version_requested"],
                       result["updated_at"]
                      )
            end
        end
    end
  end
end
