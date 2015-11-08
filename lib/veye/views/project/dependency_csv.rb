require_relative '../base_csv.rb'

module Veye
  module Project
    class DependencyCSV < BaseCSV
      def initialize
        headings = "nr,name,prod_key,outdated,current,requested,stable,licenses"
        super(headings)
      end

      def format(results, filename = nil)
        return nil if results.nil?
        results = [results] if results.is_a?(Hash)

        results.each_with_index do |result, index|
          if filename.nil?
            print_line(result, index + 1)
          else
            print_line_with_filename(result, index + 1, filename)
          end
        end
      end

      def print_line(result, i)
        printf("%d,%s,%s,%s,%s,%s,%s,%s\n",
               i,
               result['name'],
               result['prod_key'],
               result['outdated'],
               result['version_current'],
               result['version_requested'],
               result['stable'],
               result['licenses'].to_a.map {|x| x['name']}.join(';'))
      end

      def print_line_with_filename(result, i, filename)
        printf("%d,%s,%s,%s,%s,%s,%s,%s,%s\n",
               i, filename,
               result['name'],
               result['prod_key'],
               result['outdated'],
               result['version_current'],
               result['version_requested'],
               result['stable'],
               result['licenses'].to_a.map {|x| x['name']}.join(';'))
      end

    end
  end
end
