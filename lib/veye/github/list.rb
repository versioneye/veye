require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    # List class includes methods to see importable Github repositories
    class List < BaseExecutor
      @output_formats = {
        'csv'     => Github::ListCSV.new,
        'json'    => Github::ListJSON.new,
        'pretty'  => Github::ListPretty.new,
        'table'   => Github::ListTable.new
      }

      def self.get_list(api_key, options)
        results = Veye::API::Github.get_list(
          api_key, options[:page], options[:lang],
          options[:private], options[:org], options[:org_type]
        )
        if valid_response?(results, 'No repositories.')
          paging = results.data['paging']
          show_results(@output_formats, results.data, options, paging)
        end
      end
    end
  end
end
