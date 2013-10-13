require_relative '../base_table.rb'

module Veye
  module User
    class FavoriteTable < BaseTable
      def initialize
        headings = %w(nr name product_key version language)
        super("Favorite packages", headings)
      end

      def make_row(fav, index)
        [index + 1, fav['name'], fav['prod_key'], fav['version'], fav['language']]
      end

      def format(results)
        return if results.nil?
        items = results['favorites']
        return if items.nil?
        items.each_with_index {|fav, index| @table << make_row(fav, index)}
      end

    end
  end
end
