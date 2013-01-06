module Veye
  module SearchFormat
    class JSON 

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
