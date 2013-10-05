require 'terminal-table'

module Veye
  module Project
    class ProjectDependencyTable
      def before
        @@table = Terminal::Table.new :title => "Version check",
          :headings => %w(index name prod_key version_current version_latest outdated stable)
        @@table.align_column(0, :right)
      end

      def after
        puts @@table.to_s
      end

      def format(results)
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|
          row = [index + 1, result["name"], result["prod_key"], 
                  result["version_current"], result["version_requested"],
                  result['outdated'] ? 'outdated':'', result['stable'] ? 'stable': 'unstable']
          @@table << row
        end
      end
    end
  end
end
