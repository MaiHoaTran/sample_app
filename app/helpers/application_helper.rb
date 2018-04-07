module ApplicationHelper
  def full_title page_title = ""
    if page_title.blank?
      I18n.t "static_pages.base_title"
    else
      page_title + " | " + I18n.t("static_pages.base_title")
    end
  end
end
