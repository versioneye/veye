require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    class List < BaseExecutor

      @@output_formats = {
        'csv'     => Github::ListCSV.new,
        'json'    => Github::ListJSON.new,
        'pretty'  => Github::ListPretty.new,
        'table'   => Github::ListTable.new
      }

      def self.get_list(api_key, options)
        results = Veye::API::Github.get_list(api_key, options[:page], options[:lang],
                                             options[:private], options[:org],
                                             options[:org_type])
        if valid_response?(results, "No repositories.")
          show_results(@@output_formats, results.data, options, results.data['paging'])
        end
      end
    end
  end
end

