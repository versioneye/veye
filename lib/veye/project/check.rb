require_relative '../views/project.rb'
require_relative '../base_executor.rb'

module Veye
  module Project
    # Check class includes methods to check and upload project files
    class Check < BaseExecutor
      extend FormatHelpers

      @output_formats = {
        'csv'       => Project::InfoCSV.new,
        'json'      => Project::InfoJSON.new,
        'pretty'    => Project::InfoPretty.new,
        'table'     => Project::InfoTable.new,
        'md'        => Project::InfoMarkdown.new
      }

      @dependency_output_formats = {
        'csv'       => Project::DependencyCSV.new,
        'json'      => Project::DependencyJSON.new,
        'pretty'    => Project::DependencyPretty.new,
        'table'     => Project::DependencyTable.new,
        'md'        => Project::DependencyMarkdown.new
      }

      def self.get_list(api_key, options)
        results = Veye::API::Project.get_list(api_key)
        catch_request_error(results, 'Can not read list of projects.')
        show_results(@output_formats, results.data, options)
      end

      def self.upload(filename, api_key, options)
        results = Veye::API::Project.upload(api_key, filename)
        catch_request_error(results, 'Upload failed.')
        show_results(@output_formats, results.data, options)
        show_dependencies(results.data, options)
      end

      def self.update(project_key, filename, api_key, options)
        results = Veye::API::Project.update(api_key, project_key, filename)
        catch_request_error(results, 'Re-upload failed.')
        show_results(@output_formats, results.data, options)
        show_dependencies(results.data, options)
      end

      def self.get_project(project_key, api_key, options)
        results = Veye::API::Project.get_project(api_key, project_key)
        err_msg = "No data for the project: `#{project_key}`"
        catch_request_error(results, err_msg)
        show_results(@output_formats, results.data, options)
        show_dependencies(results.data, options)
      end

      def self.delete_project(project_key, api_key)
        results = Veye::API::Project.delete_project(api_key, project_key)
        err_msg = "Failed to delete project: `#{project_key}`"
        catch_request_error(results, err_msg)
        show_message(results, 'Deleted', 'Cant delete.')
      end

      #-- layout helpers
      def self.filter_dependencies(results, options)
        if options[:all]
           results['dependencies'].to_a.sort_by {|x| x['outdated'].hash}
         else
           results['dependencies'].to_a.keep_if {|x| x['outdated']}
         end
      end
      
      def self.show_dependencies(results, options)
        format = options[:format]
        format ||= 'pretty'
        return if format == 'json'
        self.supported_format?(@dependency_output_formats, format)

        deps = filter_dependencies(results, options)     
        formatter = @dependency_output_formats[format]
        formatter.before
        formatter.format deps
        formatter.after
      end

      def self.show_message(results, success_msg, fail_msg)
        if results.success
          printf "#{success_msg}\n".color(:green)
        else
          printf("Error: %s\n%s\n",
                 fail_msg.color(:red),
                 response.data['error'])
        end
      end
    end
  end
end
