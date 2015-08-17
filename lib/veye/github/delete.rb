require_relative '../base_executor.rb'

module Veye
  module Github
    class Delete < BaseExecutor

      def self.delete_repo(api_key, repo_name, options)
        response = Veye::API::Github.delete_repo(api_key, repo_name, options[:branch])
        show_result(response)
      end

      def self.show_result(response)
        unless response.success
          printf("Cant delete - %s\n%s\n", response.message.color(:red),
                                           response.data['error'])
        else
          printf "Deleted\n".color(:green)
        end
      end
    end
  end
end

