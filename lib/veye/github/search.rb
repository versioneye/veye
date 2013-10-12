require_relative '../views/github.rb'
require_relative '../base_executor.rb'

module Veye
  module Github
    class Search < BaseExecutor
      @@output_formats = {
        'csv'     => Github::SearchCSV.new,
        'json'    => Github::SearchJSON.new,
        'pretty'  => Github::SearchPretty.new,
        'table'   => Github::SearchTable.new
      }

      def self.search(api_key, search_term, options)
        github_api = API::Resource.new(RESOURCE_PATH)
        results = nil
        params = {api_key: api_key, q: search_term}
        params[:langs] = options[:lang] unless options[:lang].nil?
        params[:users] = options[:user] unless options[:user].nil?
        params[:page]  = options[:page] || "1"
        qparams = {params: params}

        github_api.resource["/search"].get(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "No match")
        show_results(@@output_formats, results.data, options, results.data['paging'])
        results
      end
    end
  end
end

