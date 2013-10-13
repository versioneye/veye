class BaseJSON

  def initialize
    @results = {}
  end

  def before; end

  def after(paging = nil, allow_pagination = false)
    if allow_pagination && !paging.nil?
      @results[:paging] = paging
    end

    puts @results.to_json
  end

  def format(results)
    raise NotImplementedError
  end
end