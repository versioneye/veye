require 'terminal-table'

module Veye
  module Package
    class InfoTable
      def before
        @@table = Terminal::Table.new :title => "Package information",
                                      :headings => %w(name version product_key language description)
        @@table.align_column(0, :right)
      end

      def after
        puts @@table.to_s
      end

      def format(result)
        row = [result["name"], result["version"], result["prod_key"]]
        row << result["language"]
        row << result["description"]

        @@table << row

        @@table << ["", "", "", "link:", result["link"]]
      end
    end

  end
end

