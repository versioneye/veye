require_relative 'search_csv.rb'
require_relative 'search_json.rb'
require_relative 'search_pretty.rb'
require_relative 'search_table.rb'

module Veye
  module Package
    
    class Search
        @@output_formats = {
            'csv'       => SearchCSV.new,
            'json'      => SearchJSON.new,
            'pretty'    => SearchPretty.new,
            'table'     => SearchTable.new
        }

        def self.search(search_term, language = nil, group_id = nil, page = nil)
            search_api = Veye::API::Resource.new "#{RESOURCE_PATH}/search"
            search_response = nil
            search_params = {:q => search_term.to_s}

            search_params[:lang] = Package.encode_language(language) unless language.nil?
            search_params[:g] = group_id unless group_id.nil?
            search_params[:page] = page unless page.nil?

            request_params = {:params => search_params}
            search_api.resource["/#{search_term}"].get(request_params) do |response, request, result, &block|
                search_response = API::JSONResponse.new(request, result, response)    
            end

            return search_response
        end

        def self.format(search_results, format = 'pretty', paging = nil)
            
            formatter = @@output_formats[format]
            formatter.before
            formatter.format(search_results)
            formatter.after paging
        end
        
    end

  end
end
