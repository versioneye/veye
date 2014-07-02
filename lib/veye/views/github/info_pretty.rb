require_relative '../base_pretty.rb'

module Veye
  module Github
    class InfoPretty < BasePretty

      def format(result)
        return if result.nil?
        repo = result['repo']
        projects = result['imported_projects']
        if projects
          project_names = projects.map {|x| x['project_key']}
        else
          project_names = []
        end

        printf(
          "\t%15s - %s\n",
          "#{repo['fullname']}".color(:green),
          "#{repo['language']}".bright
        )
        printf("\t%-15s: %s\n", "Description", repo['description'])
        printf("\t%-15s: %s\n", "Owner login", repo['owner_login'])
        printf("\t%-15s: %s\n", "Owner type", repo['owner_type'])
        printf("\t%-15s: %s\n", "Private", repo['private'])
        printf("\t%-15s: %s\n", "Fork", repo['fork'])
        printf("\t%-15s: %s\n", "Branches", repo['branches'].to_a.join(', '))
        printf("\t%-15s: %s\n", "Imported", project_names.join(', '))
        printf("\t%-15s: %s\n", "Html url", repo['html_url'])
        printf("\t%-15s: %s\n", "Git url", repo['git_url'])

     end
    end
  end
end
