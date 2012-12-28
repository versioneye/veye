module Veye

    class PackageSearch
        def self.search(search_term, language = nil, group_id = nil, page = nil)
            search_params = {:q => search_term}
            search_api = Veye::API::Resource.new "/products/search"

            search_params[:lang] = language unless language.nil?
            search_params[:g] = group_id unless group_id.nil?
            search_params[:page] = page unless page.nil?

            request_params = {:params => search_params}
            search_api.resource["/#{search_term}.json"].get(request_params) do |response, request, result, &block|
                if result.code.to_i == 200
                    search_results = JSON.parse(response)
                    PackageSearch.print_results(search_params, search_results)
                else
                    puts "#{"Error".foreground(:yellow)}`: search request failed."
                end

            end
        end

        def self.print_results(search_params, search_results)
            if search_results.empty?
                puts "No results for `#{search_params[:q].foreground(:yellow)}` with given parameters: #{search_params}"
            else
                ap search_results
            end

        end
    end
end
