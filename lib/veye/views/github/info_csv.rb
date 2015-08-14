require_relative '../base_csv.rb'

module Veye
  module Github
    class InfoCSV < BaseCSV
      def initialize
        headers = "name,language,owner_login,owner_type,private,fork,branches,imported_projects,description"
        super(headers)
      end
      def format(results)
        return nil if results.nil?
        repo = results['repo']
        imported_projects = results['imported_projects']
        imported_project_names = imported_projects.map {|p| p['project_key']}
        printf(
          "%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
          repo['fullname'],
          repo['language'],
          repo['owner_login'],
          repo['owner_type'],
          repo['private'],
          repo['fork'],
          repo['branches'].to_a.join('|'),
          imported_project_names.to_a.join('|'),
          repo['description']
        )
      end
    end
  end
end
