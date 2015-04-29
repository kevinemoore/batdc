module ApplicationHelper
  def phone_number_link(text)
    if text
      sets_of_numbers = text.scan(/[0-9]+/)
      number = "+1-#{sets_of_numbers.join('-')}"
      link_to text, "tel:#{number}"
    else
      nil
    end
  end

  def phone_number_link_mobile(text)
    if text
      sets_of_numbers = text.scan(/[0-9]+/)
      number = "+1-#{sets_of_numbers.join('-')}"
      link_to '', "tel:#{number}", class: "btn btn-default glyphicon glyphicon glyphicon-earphone"
    else
      nil
    end
  end

  def mail_to_mobile(email)
    if email and not email.blank?
      link_to '', "mailto:#{email}", class: "btn btn-default glyphicon glyphicon-envelope"
    else
      nil
    end
  end
end


