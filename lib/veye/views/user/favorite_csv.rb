require_relative '../base_csv.rb'

module Veye
  module User
    class FavoriteCSV < BaseCSV
      def initialize
        headers = "index,name,prod_key,prod_type,version,language"
        super(headers)
      end

      def format(results)
        return nil if results.nil?
        items = results['favorites']
        return if items.nil?
        items.each_with_index {|result, index| print_row(result, index)}
      end

      def print_row(result, index = 1)
        row = sprintf("%d,%s,%s,%s,%s,%s\n",
                      index + 1,
                      result['name'],
                      result['prod_key'],
                      result['prod_type'],
                      result['version'],
                      result['language']
                     )
        puts row
      end
    end
  end
end

