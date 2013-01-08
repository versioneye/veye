module Veye
    module Format
        class SearchCSV
          def before; end
          def after; end
            
          def format(result, index)
            printf("%d,%s,%s,%s\n", index, 
                   result["name"], result["version"], result["prod_key"])
          end
        end
    end
end
