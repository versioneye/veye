module Veye
  module Format
    class InfoJSON
      def before; end
      def after; end

      def format(result, index = 0)
        printf("%s\n", result.to_json)
      end
    end
  
  end
end

