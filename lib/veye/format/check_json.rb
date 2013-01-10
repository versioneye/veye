module Veye
  module Format
    class CheckJSON
        def before; end
        def after; end

        def format(results)
            printf("%s\n", results.to_json)
        end
    end
  end
end
