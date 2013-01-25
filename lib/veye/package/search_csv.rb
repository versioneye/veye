module Veye
  module Package
    class SearchCSV
      def before
        printf("nr,name,version,prod_key,version,language,group_id\n")
      end
      def after(paging = nil)
        return if paging.nil?

        printf("# ------------------------------------------\n")
        printf("current_page,per_page,total_pages,total_entries\n")
        printf("%s,%s,%s,%s\n",
              paging['current_page'],
              paging['per_page'],
              paging['total_pages'],
              paging['total_entries'])
      end
        
      def format(results)
        results.each_with_index do |result, index|
            printf("%d,%s,%s,%s,%s,%s,%s\n", 
                    index + 1, 
                    result["name"],
                    result["version"], 
                    result["prod_key"],
                    result["version"],
                    result["language"],
                    result["group_id"])
        end
      end
    end
  end
end
