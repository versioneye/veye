require 'terminal-table'

module Veye
  module Github
    class GithubInfoTable
      @@columns = %w(name language owner_login owner_type private fork branches imported_projects description)

      def before
        @table = Terminal::Table.new :title => "Repository information",
                                     :headings => @@columns

        @table.align_column(0, :right)
      end

      def after(paging = nil)
        puts @table.to_s
      end

      def format(result)
        repo = result['repo']
        projects = result['imported_projects']
        if projects
          project_names = projects.map {|x| x['project_key']}
        else
          project_name = []
        end

        row = [repo['fullname']]
        row << repo['language']
        row << repo['owner_login']
        row << repo['owner_type']
        row << repo['private']
        row << repo['fork']
        row << repo['branches'].to_a.join(', ')
        row << project_names.join(',')
        row << repo['description']

        @table << row
      end
    end
  end
end

