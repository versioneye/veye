module Veye
  module Package
    class SearchJSON 

        def before; end
        def after; end

        def format(results)
            printf(results.to_json)
        end
    end
  end
end
