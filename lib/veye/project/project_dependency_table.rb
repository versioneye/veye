require 'terminal-table'

module Veye
  module Project
    class ProjectDependencyTable

      @@columns = %w{index name prod_key outdated version_current version_requested stable license}

      def before
        @@table = Terminal::Table.new :title => "Version check",
          :headings => @@columns
        @@table.align_column(0, :right)
      end

      def after
        puts @@table.to_s
      end

      def format(results)
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|
          row = [index + 1,
            result["name"],
            result["prod_key"],
            result["version_current"],
            result["version_requested"],
            result["outdated"] ? "outdated":"",
            result["stable"] ? "stable": "unstable",
            result["license"]]
          @@table << row
        end
      end
    end
  end
end
