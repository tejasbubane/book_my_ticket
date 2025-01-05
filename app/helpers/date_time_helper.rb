module DateTimeHelper
  def format_timestamp(timestamp)
    return unless timestamp.is_a?(Time)

    timestamp.strftime("%-d %b %Y %I:%M %P")
  end
end
