require_relative '../views/user.rb'
require_relative '../base_executor.rb'

module Veye
  module User
    module API
      def self.get_profile(api_key, options)
        user_api = Veye::API::Resource.new(RESOURCE_PATH)
        qparams = {:params => {:api_key => api_key}}

        user_api.resource.get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end

      def self.get_favorites(api_key, options)
        user_api = Veye::API::Resource.new(RESOURCE_PATH)
        page = options[:page] || 1
        qparams = {
          :params => {
            :api_key => api_key,
            :page => page
          }
        }

        user_api.resource['/favorites'].get(qparams) do |response, request, result|
          Veye::API::JSONResponse.new(request, result, response)
        end
      end
    end

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
        results = API.get_profile(api_key, options)
        if valid_response?(results, "Failed to read profile.")
          show_results(@@profile_formats, results.data, options)
        end
      end

      def self.get_favorites(api_key, options)
        results = API.get_favorites(api_key, options)

        if valid_response?(results, "Failed to read favorites.")
          show_results(@@favorite_formats, results.data, options, results.data['paging'])
        end
      end
    end
  end
end
