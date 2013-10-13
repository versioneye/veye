require_relative '../views/user.rb'
require_relative '../base_executor.rb'


module Veye
  module User
    class Me < BaseExecutor

      @@profile_formats = {
        'csv'     => User::ProfileCSV.new,
        'json'    => User::ProfileJSON.new,
        'pretty'  => User::ProfilePretty.new,
        'table'   => User::ProfileTable.new
      }

      @@favorite_formats = {
        'csv'     => User::FavoriteCSV.new,
        'json'    => User::FavoriteJSON.new,
        'pretty'  => User::FavoritePretty.new,
        'table'   => User::FavoriteTable.new
      }

      def self.get_profile(api_key, options)
        user_api = API::Resource.new(RESOURCE_PATH)
        results = nil
        qparams = {:params => {:api_key => api_key}}

        user_api.resource.get(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Failed to read profile.")
        show_results(@@profile_formats, results.data, options)
        results
      end

      def self.get_favorites(api_key, options)
        user_api = API::Resource.new(RESOURCE_PATH)
        results = nil
        page = options[:page] || 1
        qparams = {
          :params => {
            :api_key => api_key,
            :page => page
          }
        }

        user_api.resource['/favorites'].get(qparams) do |response, request, result|
          results = API::JSONResponse.new(request, result, response)
        end

        catch_request_error(results, "Failed to read favorites.")
        show_results(@@favorite_formats, results.data, options, results.data['paging'])
        results
      end
    end
  end
end

