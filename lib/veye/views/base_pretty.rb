require 'rainbow'
require 'rainbow/ext/string'

class BasePretty
  def before; end
  def after(paging = nil, allow_pagination = false)
    if allow_pagination and paging
      printf("\n#-- %s\n", "Pagination information".bright)
      printf("\t%-15s: %s\n", "Current page", paging['current_page'])
      printf("\t%-15s: %s\n", "Per page", paging['per_page'])
      printf("\t%-15s: %s\n", "Total pages", paging['total_pages'])
      printf("\t%-15s: %s\n", "Total entries", paging['total_entries'])
    end
  end
  def format(results)
    raise NotImplementedError
  end
end
