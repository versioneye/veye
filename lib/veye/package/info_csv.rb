module Veye
  module Package
    class InfoCSV
      def before
        printf("name,version,language,prod_key,licence,prod_type,description,link\n")
      end
      def after; end

      def format(result, index = 0)
        printf("%s,%s,%s,%s,%s,%s,%s,%s\n",
              result["name"], result["version"], result["language"],
              result["prod_key"], result["license"], result["prod_type"],
              result["link"], result["description"])
      end
    end
  end
end

