require_relative 'github_sync_csv.rb'
require_relative 'github_sync_json.rb'
require_relative 'github_sync_pretty.rb'
require_relative 'github_sync_table.rb'

module Veye
  module Github
    class Sync
      extend FormatHelpers

      @@output_formats = {
        'csv'     => GithubSyncCSV.new,
        'json'    => GithubSyncJSON.new,
        'pretty'  => GithubSyncPretty.new,
        'table'   => GithubSyncTable.new
      }

      def self.import_all(api_key, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        response_data = nil
        params = {api_key: api_key}
        params[:force] = options[:force] unless options[:force].nil?

        qparams = {params: params}
        github_api.resource['/sync'].get(qparams) do |response, request, result|
          response_data = API::JSONResponse.new(request, result, response)
        end

        return response_data
      end

      def self.format(results, format = 'pretty', paging = nil)
        self.supported_format?(@@output_formats, format)
        
        formatter = @@output_formats[format]
        formatter.before
        formatter.format results
        formatter.after paging
      end
    end
  end
end
