module Veye
  module Github
    class GithubInfoCSV
      def before
        printf("name,language,owner_login,owner_type,private,fork,branches,imported_projects, description\n")
      end
      def after(paging); end

      def format(results, index = 0)
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
          repo['branches'].join('|'),
          imported_project_names.join('|'),
          repo['description']
        )
      end
    end
  end
end

