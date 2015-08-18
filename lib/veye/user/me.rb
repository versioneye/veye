require_relative '../views/user.rb'
require_relative '../base_executor.rb'

module Veye
  module User
    # Me class includes commands to manage and view authorized user profile
    # and favorites.
    class Me < BaseExecutor
      @profile_formats = {
        'csv'     => User::ProfileCSV.new,
        'json'    => User::ProfileJSON.new,
        'pretty'  => User::ProfilePretty.new,
        'table'   => User::ProfileTable.new
      }

      @favorite_formats = {
        'csv'     => User::FavoriteCSV.new,
        'json'    => User::FavoriteJSON.new,
        'pretty'  => User::FavoritePretty.new,
        'table'   => User::FavoriteTable.new
      }

      def self.get_profile(api_key, options)
        results = Veye::API::User.get_profile(api_key)
        if valid_response?(results, 'Failed to read profile.')
          show_results(@profile_formats, results.data, options)
        end
      end

      def self.get_favorites(api_key, options)
        results = Veye::API::User.get_favorites(api_key, options[:page])

        if valid_response?(results, 'Failed to read favorites.')
          paging = results.data['paging']
          show_results(@favorite_formats, results.data, options, paging)
        end
      end
    end
  end
end
