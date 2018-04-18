module UsersHelper
  def gravatar_for user, size: Settings.user.size_avatar
    gravater_id = Digest::MD5.hexdigest(user.email.downcase)
    gravater_url = "https://secure.gravatar.com/avatar/#{gravater_id}?s=#{size}"
    image_tag(gravater_url, alt: user.name, class: "gravatar")
  end
end
