require_relative '../base_executor.rb'

module Veye
  module Github
    # Sync class is responsible for updating info on VersionEye
    class Sync < BaseExecutor
      def self.import_all(api_key, options)
        response = Veye::API::Github.import_all(api_key, options[:force])
        catch_request_error(response, 'Can not import repositories from Github')
        show_result(response)
      end

      def self.show_result(response)
        if response.data['changed']
          printf "Imported. #{response.data['msg']}\n".color(:green)
        else
          printf("%s - %s\n",
                 'No changes.'.color(:red),
                 'Use `force` flag if you want to reload everything.')
        end
      end
    end
  end
end
