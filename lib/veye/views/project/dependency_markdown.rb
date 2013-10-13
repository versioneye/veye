require_relative '../base_markdown.rb'

module Veye
  module Project
    class DependencyMarkdown < BaseMarkdown
      def initialize
        headings =  %w{index name prod_key outdated version_current version_requested stable license}
        super("Project dependencies", headings)
      end

      def format(results)
        return if results.nil?
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|
          @table << [
            (index + 1).to_s,
            result["name"],
            result["prod_key"],
            result["outdated"] ? "outdated" : "ok",
            result["version_current"],
            result["version_requested"],
            result["stable"] ? "stable": "unstable",
            result["license"]
            ]
        end
      end
    end
  end
end

