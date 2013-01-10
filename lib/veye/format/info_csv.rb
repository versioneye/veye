module Veye
  module Format
    class InfoCSV
      def before
        printf("name,version,language,prod_key,licence,prod_type,description,link\n")
      end
      def after; end

      def format(result, index = 0)
        printf("%s,%s,%s,%s,%s,%s,%s,%s",
              result["name"], result["version"], result["language"],
              result["prod_key"], result["license"], result["prod_type"],
              result["link"], result["description"])
      end
    end
  end
end

