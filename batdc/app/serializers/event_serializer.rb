class EventSerializer < ActiveModel::Serializer
  attributes :event_name, :start_date, :end_date, :school, :url, :description  

end
