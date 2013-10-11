require 'rainbow'

module Veye
  module Github
    class GithubInfoPretty
      def before; end
      def after(paging); end

      def format(result)
        repo = result['repo']
        projects = repo['imported_projects']
        if projects
          project_names = projects.map {|x| x[:project_key]}
        else
          project_names = []
        end

        printf(
          "\t%15s - %s\n",
          "#{repo['fullname']}".foreground(:green),
          "#{repo['language']}".bright
        )
        printf("\t%-15s: %s\n", "Description", repo['description'])
        printf("\t%-15s: %s\n", "Owner login", repo['owner_login'])
        printf("\t%-15s: %s\n", "Owner type", repo['owner_type'])
        printf("\t%-15s: %s\n", "Private", repo['private'])
        printf("\t%-15s: %s\n", "Fork", repo['fork'])
        printf("\t%-15s: %s\n", "Branches", repo['branches'].to_a.join(', '))
        printf("\t%-15s: %s\n", "Imported", project_names.join(', '))

     end
    end
  end
end
