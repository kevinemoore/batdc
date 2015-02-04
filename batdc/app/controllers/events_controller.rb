class EventsController < ApplicationController
  load_and_authorize_resource except: [:create]

  before_filter :check_for_mobile, :only => [:index, :show]

  def index
    @events = Event.all
    @events = @events.search(params[:search]) if params[:search]
    @events = @events.order(start_date: :desc)
    @events = @events.paginate(page: params[:page])
  end

  def create
    @event = Event.create(event_params)
    redirect_to @event
  end

  def update
    if @event.update(event_params)
      redirect_to @event
    else
      render 'edit'
    end
  end

  def add_attendee
    ({ contact_id: params[:attendee][:contact_id],
       event_id: @event.id,
       sponsor_school_id: params[:sponsor_school_id],
       paid: params[:paid] })
    redirect_to edit_event_path(@event)
  end
  
  private
  def event_params
    params.require(:event).permit(:eventbrite_id, :event_name,
  :event_type, :series, :start_date, :end_date, :venue, :url,
  :description, :notes, :num_sessions)
  end

end
