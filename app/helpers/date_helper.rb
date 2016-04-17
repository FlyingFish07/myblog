module DateHelper
  def format_month(date)
    l date, format: :month
    # date.strftime("%B %Y")
  end

  def format_post_date(date)
    date.strftime("%B %d, %Y")
  end

  def format_comment_date(date)
    l date, format: :long
    # format_post_date(date) + " at " + date.strftime("%l:%M %p")
  end
  def format_create_date(date)
    l date, format: :long
    # format_post_date(date) + " at " + date.strftime("%l:%M %p")
  end
end
