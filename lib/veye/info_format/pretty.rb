require 'rainbow'

module Veye
  module InfoFormat
    class Pretty
      def before; end
      def after; end

      def format(result, index = 0)
        printf("%25s - %s", "#{result['name']}".foreground(:green).bright,
                            "#{result['version'].bright}")
        printf("\t%-15s: %s\n", "Language", result["language"])
        printf("\t%-15s: %s\n", "Licence", result["licence"])
        
        printf("\t%-15s: %s\n", "Product type", result["prod_type"])
        printf("\t%-15s: %s\n", "Product key", 
               "#{result["prod_key"]}".bright)
        printf("\t%-15s:\n %s", "Description", result["description"])
        if result.has_key? "group_id" and not result["group_id"].empty? 
          printf("\t%-15s: %s\n", "Group id", result["group_id"])
        end
        printf("\t%-15s: %s\n", "Link", result["link"])

      end
    end
  
  end
end
