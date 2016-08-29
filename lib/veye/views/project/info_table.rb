require_relative '../base_table.rb'

module Veye
  module Project
    class InfoTable < BaseTable
      def initialize
        headings = %w(index name project_id public period source dependencies outdated created_at)
        super("List of projects", headings)
      end

      def format(results)
        return if results.nil?
        results = [results] if results.is_a? Hash

        results.each_with_index do |result, index|
          #BUG: API returns raw mongoID value as id when fetching a list of projects
          if result['id'].is_a?(Hash)
            result['id'] = result['id'].values.first 
          end

          row = [index + 1, result['name'], result['id'],
                 result['public'], result['period'], result['source'],
                 result['dep_number'], result['out_number'], result['created_at']]
          @table << row
         end
      end
    end
  end
end

