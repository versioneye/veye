require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    # This class includes commands for Package search and
    # presentation renderers.
    class Search < BaseExecutor
      @output_formats = {
        'csv'       => Package::SearchCSV.new,
        'json'      => Package::SearchJSON.new,
        'pretty'    => Package::SearchPretty.new,
        'table'     => Package::SearchTable.new
      }

      def self.search(api_key, search_term, options)
        results = Veye::API::Package.search(
          api_key, search_term, options[:language],
          options['group-id'], options[:page]
        )
        if valid_response?(results, "No results for `#{search_term}`")
          show_results(@output_formats,
                       results.data, options,
                       results.data['paging'])
        end
      end
    end
  end
end
