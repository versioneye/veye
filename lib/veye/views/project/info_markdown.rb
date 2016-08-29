require_relative '../base_markdown.rb'

module Veye
  module Project
    class InfoMarkdown < BaseMarkdown
      def initialize
        headings  = %w(index name project_id project_type public period source dependencies outdated created)
        super("Project's information", headings)
      end

      def format(results)
        return if results.nil?

        results = [results] if results.is_a?(Hash) #required for  `project show`
        results.each_with_index do |result, index|
          #BUG: API returns raw mongoID value as id when fetching a list of projects
          if result['id'].is_a?(Hash)
            result['id'] = result['id'].values.first 
          end
 
          @table << [
            (index + 1).to_s,
            result["name"],
            result["id"],
            result["project_type"],
            result["public"].to_s,
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
