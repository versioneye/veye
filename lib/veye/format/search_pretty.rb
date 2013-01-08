require 'rainbow'

module Veye
    module Format
        class SearchPretty
            def before; end
            def after; end

            def format(result, index)
                printf("%3d - %s\n", index, "#{result["name"]}".foreground(:green).bright)
                printf("\t%-15s: %s\n", "Product key", result["prod_key"])
                printf("\t%-15s: %s\n", "Latest version", 
                       "#{result["version"]}".bright)
                if result.has_key? "group_id" and not result["group_id"].empty? 
                  printf("\t%-15s: %s\n", "Group id", result["group_id"])
                end

            end
        end
    end
end
