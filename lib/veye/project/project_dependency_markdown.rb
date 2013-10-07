require 'render-as-markdown'

module Veye
  module Project
    class ProjectDependencyMarkdown

      @@columns =  %w{index name prod_key outdated version_current version_requested stable license}

      def before; end

      def format(results)
        begin
          markdown = "# Dependencies\n\n"

          table = RenderAsMarkdown::Table.new @@columns

          results = [results] if results.is_a?(Hash)

          results.each_with_index do |result, index|
            # make sure this array is exactly as long as @@columns
            table << [
              (index + 1).to_s,
              result["name"],
              result["prod_key"],
              result["outdated"] ? "outdated":"",
              result["version_current"],
              result["version_requested"],
              result["stable"] ? "stable": "unstable",
              result["license"]
              ]
          end

          markdown << table.render
          puts markdown

        rescue => e
          puts e
          puts e.backtrace
        end
      end

      def after; end

    end
  end
end

