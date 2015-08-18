require_relative '../base_executor.rb'

module Veye
  module Github
    # Delete class include methods to cleanup projects imported from Github
    class Delete < BaseExecutor
      def self.delete_repo(api_key, repo_name, options)
        response = Veye::API::Github.delete_repo(
          api_key, repo_name, options[:branch]
        )
        show_result(response)
      end

      def self.show_result(response)
        if response.success
          printf "Deleted\n".color(:green)
        else
          printf("Cant delete - %s\n%s\n",
                 response.message.color(:red),
                 response.data['error'])
        end
      end
    end
  end
end
