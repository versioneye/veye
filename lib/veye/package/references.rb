require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    # Commands to view package references
    class References < BaseExecutor
      @output_formats = {
        'csv'       => Package::ReferencesCSV.new,
        'json'      => Package::ReferencesJSON.new,
        'pretty'    => Package::ReferencesPretty.new,
        'table'     => Package::ReferencesTable.new
      }

      def self.get_references(api_key, prod_key, language='ruby', options = {})
        results = Veye::API::Package.get_references(api_key, prod_key, language, options[:page])

        if valid_response?(results, "No references for: `#{prod_key}`, language: #{language}")
          paging = results.data['paging']
          show_results(@output_formats, results.data, options, paging)
        end
      end
    end
  end
end
