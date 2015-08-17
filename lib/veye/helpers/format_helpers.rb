require 'rainbow/ext/string'

# FormatHelpers module includes common helper functions
# for output rendering.
module FormatHelpers
  def supported_format?(output_formats, format)
    formats_attached?(output_formats) && format_exists?(output_formats, format)
  end

  def formats_attached?(output_formats)
    if output_formats.nil?
      p 'Executor doesnt have any formattor defined.'.color(:red)
    end
    !output_formats.nil?
  end

  def format_exists?(output_formats, format)
    unless output_formats.key?(format)
      msg = "Unsupported output format: `#{format}`\n".color(:red)
      msg += "Supported formats: #{output_formats.keys.join(', ')}\n"
      p msg
      return false
    end
    true
  end
end
