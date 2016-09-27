require_relative '../base_markdown.rb'

module Veye
  module Project
    class DependencyMarkdown < BaseMarkdown
      def initialize
        headings =  %w{index name prod_key outdated version_current version_requested stable license, upgrade_cost}
        super("Project dependencies", headings)
      end

      def format(results)
        return if results.nil?
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|

          upgrade_cost = if result.has_key?(:upgrade)
                          "#{result[:upgrade][:difficulty]}(#{result[:upgrade][:dv_score]})"
                         else
                           ''
                         end
          @table << [
            (index + 1).to_s,
            result["name"],
            result["prod_key"],
            result["outdated"] ? "outdated" : "ok",
            result["version_current"],
            result["version_requested"],
            result["stable"] ? "stable": "unstable",
            result["licenses"].to_a.map {|x| x['name']}.join(','),
            upgrade_cost
            ]
        end
      end
    end
  end
end

