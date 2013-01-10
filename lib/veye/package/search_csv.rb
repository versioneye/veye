module Veye
  module Package
    class SearchCSV
      def before
        printf("nr,name,version,prod_key\n")
      end
      def after; end
        
      def format(results)
        results.each_with_index do |result, index|
            printf("%d,%s,%s,%s\n", index, 
                                    result["name"],
                                    result["version"], 
                                    result["prod_key"])
        end
      end
    end
  end
end
