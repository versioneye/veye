module Veye
  module Format
    class SearchJSON 

        def before
            @@results = []
        end
        def after
            printf("%s\n", @@results.to_json) 
        end

        def format(result, index)
            result[:index] = index
            @@results << result
        end
    end
  end
end
