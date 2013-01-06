require_relative 'search_format/csv.rb'
require_relative 'search_format/json.rb'
require_relative 'search_format/pretty.rb'
require_relative 'search_format/table.rb'

module Veye

    class PackageSearch
        @@output_formats = {
            'csv'       => Veye::SearchFormat::CSV.new,
            'json'      => Veye::SearchFormat::JSON.new,
            'pretty'    => Veye::SearchFormat::Pretty.new,
            'table'     => Veye::SearchFormat::Table.new
        }

        def self.search(search_term, language = nil, group_id = nil, page = nil)
            search_params = {:q => search_term}
            search_api = Veye::API::Resource.new "/products/search"
            
            search_params[:lang] = language unless language.nil?
            search_params[:g] = group_id unless group_id.nil?
            search_params[:page] = page unless page.nil?

            request_params = {:params => search_params}
            search_results = []
            search_api.resource["/#{search_term}.json"].get(request_params) do |response, request, result, &block|
                
                search_results = JSON.parse(response) if result.code.to_i == 200
            end

            response =  {:params => search_params, :results => search_results}
            return response
        end

        def self.format(search_results, format = 'pretty')
            
            formatter = @@output_formats[format]
            formatter.before
            search_results.each_with_index do |result, index|
                formatter.format(result, index)
            end
            formatter.after
        end
        
    end
end
