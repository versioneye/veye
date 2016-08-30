require_relative '../views/project'
require_relative '../base_executor'

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

      def self.get_list(api_key, org_name = 'private', team_name = nil, options)
        results = Veye::API::Project.get_list(api_key, org_name, team_name)
        valid_response?(results, 'Can not read list of projects.')
        show_results(@output_formats, results.data, options)
      end

      def self.get_project(api_key, project_key, options)
        results = Veye::API::Project.get_project(api_key, project_key)
        err_msg = "No data for the project: `#{project_key}`"
        valid_response?(results, err_msg)
        show_results(@output_formats, results.data, options)
        if options[:format] != 'json'
          show_dependencies(@dependency_output_formats, results.data, options)
        end
      end

      def self.upload(api_key, filename, org_name = 'private', team_name = nil, options)

        results = Veye::API::Project.upload(
          api_key, filename, org_name, team_name, options[:temporary], options[:public], options[:name]
        )

        valid_response?(results, 'Upload failed.')
        show_results(@output_formats, results.data, options)
        if options[:format] != 'json'
          show_dependencies(@dependency_output_formats, results.data, options)
        end
      end

      def self.update(api_key, project_key, filename, options)
        results = Veye::API::Project.update(api_key, project_key, filename)
        valid_response?(results, 'Re-upload failed.')
        show_results(@output_formats, results.data, options)
        if options[:format] != 'json'
          show_dependencies(@dependency_output_formats, results.data, options)
        end
      end

      #checks project file and initializes veye.json file iff it's missing
      #files - an array with filenames to check, ['Gemfile', 'bower.json']
      #path - nil or string, a relative path to the project root directory
      def self.check(api_key, path, files, options)
        project_settings = Veye::Settings.load(path)
        #initialize project settings to keep various project specific data
        if project_settings.nil?
          file_map = files.to_a.inject({}) {|acc, x| acc.store(x, nil); acc}
          opts = {'projects' => file_map}
          project_settings = Veye::Settings.init(path, opts)
        end

        unless project_settings.has_key?('projects')
          printf "veye.json is malformed - missing `project` key".color(:red)
          exit 0
        end

        deps = {}
        project_settings['projects'].each do |filename, project_id|
          filepath = "#{path}/#{filename}"
          results = if project_id.to_s.empty?
                      Veye::API::Project.upload(api_key, filepath)
                    else
                      Veye::API::Project.update(api_key, project_id, filepath)
                    end
          error_msg = "Failed to check dependencies for `#{filename.to_s.color(:red)}`"
          if valid_response?(results, error_msg)
            deps[filename] = results.data
            project_settings['projects'].store(filename, results.data['id'])
          else
            deps[filename] = {error: "Failed to check a file `#{filepath}`"}
          end
        end

        Veye::Settings.dump(path, project_settings)
        printf(
          "Checked files: %s\nproject ids are saved into `%s`\n",
          files.to_a.join(', ').to_s.color(:green),
          "veye.json".color(:yellow)
        )
        show_bulk_dependencies(@dependency_output_formats, deps, options)
      end

      def self.delete_project(api_key, project_key)
        results = Veye::API::Project.delete_project(api_key, project_key)
        err_msg = "Failed to delete project: `#{project_key}`"
        valid_response?(results, err_msg)
        show_message(results, 'Deleted', 'Cant delete.')
      end
    end
  end
end
