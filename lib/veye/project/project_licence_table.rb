require 'terminal-table'

module Veye
  module Project
    class ProjectLicenceTable
      def before 
        @@table = Terminal::Table.new :title => "Licences",
                  :headings => %w(index licence product_keys)

        @@table.align_column(0, :right)
      end
      
      def after
        puts @@table.to_s
      end

      def format(results) 
        n = 1
        results["licenses"].each_pair do |licence, products|
          products.each do |prod|
            row = [n, licence, prod["prod_key"]]
            @@table << row
          end
          n += 1
        end
      end
    end
  end
end
