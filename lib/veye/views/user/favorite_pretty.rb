require_relative '../base_pretty.rb'

module Veye
  module User
    class FavoritePretty < BasePretty
      def format(results)
        return if results.nil?
        items = results['favorites']
        items.each_with_index {|fav, index| print_row(fav, index)}
      end
      def print_row(fav, index)
        printf(
          "\t%15s - %s\n",
          "#{fav['name']}".color(:green).bright,
          "#{fav['prod_key'].bright}"
        )
        printf("\t%-15s: %s\n", "Product type", fav['prod_type'])
        printf("\t%-15s: %s\n", "Version", "#{fav['prod_type']}".bright)
        printf("\t%-15s: %s\n", "Language", fav['language'])
      end
    end
  end
end
