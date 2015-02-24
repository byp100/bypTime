module MembersHelper
  def gravatar_for member
    gravatar_id = Digest::MD5::hexdigest(member.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: member.name, class: "gravatar")
  end
end
