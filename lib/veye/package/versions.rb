require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    class Versions < BaseExecutor
      @output_formats = {
        'csv'     => Package::VersionsCSV.new,
        #'json'    => Package::VersionsJSON.new,
        #'pretty'  => Package::VersionsPretty.new,
        #'table'   => Package::VersionsTable.new
      }
    
      def self.get_list(api_key, prod_key, lang = 'ruby', n = 10, from = 0, options = {})
        results = Veye::API::Package.get_version_list(api_key, prod_key, lang)
        err_msg = "Found no versions for #{lang} package `#{prod_key}`"

        if valid_response?(results, err_msg)
          #filter out extra rows and show only items in the window
          items = results.data['versions'].to_a.drop(from).take(n)
          results.data['versions'] = items

          show_results(@output_formats, results.data, options)
        end
      end
    end
  end
end
