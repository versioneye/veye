require 'render-as-markdown'

module Veye
  module Project
    class ProjectMarkdown
      @@columns  = %w(index name project_key project_type private period source dependencies outdated created)

      def before
        @@markdown = "# Project's information\n\n"
        @@table = RenderAsMarkdown::Table.new @@columns
      end

      def after
        @@markdown << @@table.render
        @@markdown << "\n\n"
        puts @@markdown
      end
      def format(results)
        results = [results] if results.is_a?(Hash) #required for  `project show`
        
        results.each_with_index do |result, index|
          @@table << [
            (index + 1).to_s,
            result["name"],
            result["project_key"],
            result["project_type"],
            result["private"].to_s,
            result["period"],
            result["source"],
            result["dep_number"].to_s,
            result["out_number"].to_s,
            result["created_at"]
          ]
        end
      end
    end
  end
end
