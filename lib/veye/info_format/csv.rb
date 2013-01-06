module Veye
  module InfoFormat
    class CSV
      def before; end
      def after; end

      def format(result, index = 0)
        printf("%s,%s,%s,%s,%s,%s,%s,%s",
              result["name"], result["version"], 
              result["language"], result["prod_key"],
              result["license"], result["prod_type"],
              result["description"], result["link"])
      end
    end
  end
end

