require_relative '../views/package.rb'
require_relative '../base_executor.rb'

module Veye
  module Package
    class Search < BaseExecutor
      @@output_formats = {
          'csv'       => Package::SearchCSV.new,
          'json'      => Package::SearchJSON.new,
          'pretty'    => Package::SearchPretty.new,
          'table'     => Package::SearchTable.new
      }

      def self.search(search_term, options)
        search_api = Veye::API::Resource.new "#{RESOURCE_PATH}/search"
        language = options[:language]
        group_id = options["group-id"]
        page = options[:page] || "1"
        results = nil
        search_params = {:q => search_term.to_s}

        search_params[:lang] = Package.encode_language(language) unless language.nil?
        search_params[:g] = group_id unless group_id.nil?
        search_params[:page] = page unless page.nil?

        request_params = {:params => search_params}
        search_api.resource["/#{search_term}"].get(request_params) do |response, request, result, &block|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "No results for `${search_term}`")
        show_results(@@output_formats, results.data, options, results.data['paging'])
        return results
      end
    end

  end
end
