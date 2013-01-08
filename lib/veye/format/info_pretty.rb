require 'rainbow'

module Veye
  module Format
    class InfoPretty
      def before; end
      def after; end

      def format(result, index = 0)
        printf("\t%15s - %s\n", "#{result['name']}".foreground(:green).bright,
                            "#{result['version'].bright}")
        puts "\t-------------------------"
        printf("\t%-15s: %s\n", "Language", result["language"])
        printf("\t%-15s: %s\n", "Licence", result["licence"])
        
        printf("\t%-15s: %s\n", "Product type", result["prod_type"])
        printf("\t%-15s: %s\n", "Product key", 
               "#{result["prod_key"]}".bright)
        printf("\t%-15s:\n\t %s\n", "Description", result["description"])
        if result.has_key? "group_id" and not result["group_id"].empty? 
          printf("\t%-15s: %s\n", "Group id", result["group_id"])
        end
        printf("\t%-15s: %s\n", "Link", result["link"])

      end
    end
  
  end
end
