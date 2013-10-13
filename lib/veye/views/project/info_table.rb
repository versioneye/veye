require_relative '../base_table.rb'

module Veye
  module Project
   class InfoTable < BaseTable
      def initialize
        headings = %w(index name project_key private period source dependencies outdated created_at)
        super("List of projects", headings)
      end
      def format(results)
        return if results.nil?
        results = [results] if results.is_a? Hash

        results.each_with_index do |result, index|
          row = [index + 1, result['name'], result['project_key'],
                 result['private'], result['period'], result['source'],
                 result['dep_number'], result['out_number'], result['created_at']]
          @table << row
         end
       end
   end
  end
end

