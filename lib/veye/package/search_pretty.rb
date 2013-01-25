require 'rainbow'

module Veye
  module Package
    class SearchPretty
      def before; end
      def after(paging = nil)
        return if paging.nil?

        printf("\n#-- %s\n", "Pagination information".bright)
        printf("\t%-15s: %s\n", "Current page", paging['current_page'])
        printf("\t%-15s: %s\n", "Per page", paging['per_page'])
        printf("\t%-15s: %s\n", "Total pages", paging['total_pages'])
        printf("\t%-15s: %s\n", "Total entries", paging['total_entries'])

      end

      def format(results)
        results.each_with_index do |result, index|
          printf("%3d - %s\n", 
                 index + 1,
                 "#{result["name"]}".foreground(:green).bright)
          printf("\t%-15s: %s\n", "Product key", result["prod_key"])
          printf("\t%-15s: %s\n", "Latest version", 
                                  "#{result["version"]}".bright)
          printf("\t%-15s: %s\n", "Language", result["language"])

          if result.has_key? "group_id" and not result["group_id"].empty? 
            printf("\t%-15s: %s\n", "Group id", result["group_id"])
          end
        end
      end
    end
  end
end
