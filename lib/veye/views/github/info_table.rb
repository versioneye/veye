require_relative '../base_table.rb'

module Veye
  module Github
    class InfoTable < BaseTable
      def initialize
        headings = %w(name language owner_login owner_type private fork branches imported_projects description)
        super("Repository information", headings)
      end

      def format(result)
        return if result.nil?

        repo = result['repo']
        if repo.nil?
          puts "Error: Cant import."
          return false
        end

        projects = result['imported_projects']
        if projects
          project_names = projects.map {|x| x['project_key']}
        else
          project_names = []
        end

        row = [repo['fullname']]
        row << repo['language']
        row << repo['owner_login']
        row << repo['owner_type']
        row << repo['private']
        row << repo['fork']
        row << repo['branches'].to_a.join("\n")
        row << project_names.join("\n")
        row << repo['description']

        @table << row
      end
    end
  end
end