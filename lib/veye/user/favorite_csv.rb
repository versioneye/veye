module Veye
  module User
    class FavoriteCSV
      def before
        printf("index,name,prod_key,prod_type,version,language\n")
      end
      def after; end

      def make_row(result, index = 1)
        row = sprintf("%d,%s,%s,%s,%s,%s",
                      index + 1,
                      result['name'],
                      result['prod_key'],
                      result['prod_type'],
                      result['version'],
                      result['language']
                     )
        row
      end

      def format(results)
        results = [results] if results.is_a? Hash
        results.each_with_index {|result, index| printf("%s\n", make_row(result, index))}
      end
    end
  end
end

