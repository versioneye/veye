require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    # Search - find projects on Github
    class Search < BaseExecutor
      @output_formats = {
        'csv'     => Github::SearchCSV.new,
        'json'    => Github::SearchJSON.new,
        'pretty'  => Github::SearchPretty.new,
        'table'   => Github::SearchTable.new
      }

      # TODO: add missing tests + API call test
      def self.search(api_key, search_term, options)
        results = Veye::API::Github.search(
          api_key, search_term, options[:lang], options[:user], options[:page]
        )
        catch_request_error(results, 'No match')
        paging_dt = results.data['paging']
        show_results(@output_formats, results.data, options, paging_dt)
      end
    end
  end
end
