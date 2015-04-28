class ContactSerializer < ActiveModel::Serializer
  attributes :last, :first, :role, :title, :school_name, :work_phone,
  :email, :subject

  
end
