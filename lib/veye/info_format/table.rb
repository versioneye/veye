require 'terminal-table'

module Veye
  module InfoFormat
    class Table
      def before
        @@table = Terminal::Table.new :heading => %w(name version product_key language description link)
        @@table.align_column(0, :right)
      end

      def after
        puts @@table.to_s
      end

      def format(result)
          row = [result["name"], result["version"], result["prod_key"]]
          row << result["language"]
          row << result["description"]
          row << result["link"]

          @@table << row
      end
    end

  end
end

