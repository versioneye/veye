require_relative '../base_table.rb'

module Veye
  module Project
    class DependencyTable < BaseTable
      def initialize
        headings = %w{index name prod_key version_current version_requested outdated stable license upgrade_cost}
        super("Project dependencies", headings)
      end
      def format(results, filename = nil)
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|
          upgrade_cost = if result.has_key?(:upgrade)
                          "#{result[:upgrade][:difficulty]}(#{result[:upgrade][:dv_score]})"
                         else
                           ''
                         end
          row = [
            index + 1,
            (filename or result["name"]),
            result["prod_key"],
            result["version_current"],
            result["version_requested"],
            result["outdated"] ? "outdated":"no",
            result["stable"] ? "stable": "unstable",
            result["licenses"].to_a.map {|x| x['name']}.join(','),
            upgrade_cost
          ]
          @table << row
        end
      end
    end
  end
end
