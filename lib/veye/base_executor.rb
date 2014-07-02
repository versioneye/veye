
class BaseExecutor
  extend FormatHelpers
  extend RepoHelpers

  def self.show_results(output_formats, results, options = {}, paging = nil)
    format = options[:format]
    self.supported_format?(output_formats, format)
    formatter = output_formats[format]

    formatter.before
    formatter.format(results)
    formatter.after(paging, options[:pagination])
  end

  def self.catch_request_error(response, msg)
    if response.nil? or not response.success
      error_msg = sprintf("%s\n%s\n",
                          "#{msg}".color(:red),
                          "#{response.data}")
      exit_now! error_msg
    end
  end
end
