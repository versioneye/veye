require_relative '../base_executor.rb'

module Veye
  module Package
    # Manage a following status of the software library
    class Follow < BaseExecutor
      def self.show_result(response)
        result = response.data
        return if result.nil?
        printf(
          "Following `%s`: %s\n",
          result['prod_key'],
          result['follows'].to_s.color(:green)
        )
      end

      def self.get_follow_status(api_key, prod_key, lang)
        results = Veye::API::Package.get_follow_status(api_key, prod_key, lang)
        
        if valid_response?(results, "Failed to follow #{lang} package #{prod_key}.")
          show_result(results)
        end
      end

      def self.follow(api_key, prod_key, lang)
        results = Veye::API::Package.follow(api_key, prod_key, lang)
        
        if valid_response?(results, "Cant follow #{lang} package #{prod_key}.")
          show_result(results)
        end
      end

      def self.unfollow(api_key, prod_key, lang)
        results = Veye::API::Package.unfollow(api_key, prod_key, lang)
        
        if valid_response?(results, "Cant unfollow #{lang} package #{prod_key} .")
          show_result(results)
        end
      end
    end
  end
end
