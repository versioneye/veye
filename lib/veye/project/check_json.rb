module Veye
  module Project
    class CheckJSON
      def before; end
      def after; end

      def format(results)
        printf("%s\n", {"dependencies" => results}.to_json)
      end
    end
  end
end
