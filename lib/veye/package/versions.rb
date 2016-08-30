require 'naturalsorter'

require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    class Versions < BaseExecutor
      @output_formats = {
        'csv'     => Package::VersionsCSV.new,
        'json'    => Package::VersionsJSON.new,
        'pretty'  => Package::VersionsPretty.new,
        'table'   => Package::VersionsTable.new
      }
    
      def self.get_list(api_key, prod_key, lang = 'ruby', n = 10, from = 0, options = {})
        results = Veye::API::Package.get_version_list(api_key, prod_key, lang)
        err_msg = "Found no versions for #{lang} package `#{prod_key}`"

        if valid_response?(results, err_msg)
          sorted_items = results.data['versions'].to_a.sort do |a, b| 
            Naturalsorter::Sorter.bigger?(a['version'], b['version']) ? -1 : 1
          end

          filtered_items =  if options.has_key?('all') and options['all'] == true
                              sorted_items
                            else
                              sorted_items.to_a.drop(from).take(n)
                            end
          results.data['versions'] = filtered_items

          show_results(@output_formats, results.data, options)
        end
      end
    end
  end
end
