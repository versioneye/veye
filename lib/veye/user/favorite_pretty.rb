require 'rainbow'

module Veye
  module User
    class FavoritePretty
      def before; end
      def after; end

      def show_favorite(fav, index)
        printf("\t%15s - %s\n",
               "#{fav['name']}".foreground(:green).bright,
               "#{fav['prod_key'].bright}")
        puts "\t-------------------------"
        printf("\t%-15s: %s\n", "Product type", fav['prod_type'])
        printf("\t%-15s: %s\n", "Version", "#{fav['prod_type']}".bright)
        printf("\t%-15s: %s\n", "Language", fav['language'])
      end

      def format(results)
        results = [results] if results.is_a? Hash
        results.each_with_index {|fav, index| show_favorite(fav, index)}
      end
    end
  end
end
