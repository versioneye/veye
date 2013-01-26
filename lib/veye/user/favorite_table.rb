require 'terminal-table'

module Veye
  module User
    class FavoriteTable
      def before
        @@table = Terminal::Table.new :title => "Favorite packages",
                                      :headings => %w(nr name product_key version language)
        @@table.align_column(0, :right)
      end

      def after
        puts @@table.to_s
      end

      def make_row(fav, index)
        row = [index + 1, fav['name'], fav['prod_key'], fav['version'], fav['language']]
        row
      end

      def format(results)
        results = [results] if results.is_a? Hash
        results.each_with_index {|fav, index| @@table << make_row(fav, index)}
      end

    end
  end
end
