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
    authorize! :create, Event
    if params[:commit] == "Cancel"
      redirect_to Event
    else
      @event = Event.create(event_params)
      redirect_to @event
    end
  end

  def update
    if params[:commit] == "Cancel"
      redirect_to @event
    else
      if @event.update(event_params)
        redirect_to @event
      else
        render 'edit'
      end
    end
  end

  def add_attendee
    a = Attendee.create( contact_id: params[:attendee][:contact_id],
                          event_id: @event.id,
                          sponsor_school_id: params[:attendee][:sponsor_school_id],
                          paid: params[:paid] )
    redirect_to edit_event_path(@event)
  end
  
  def email    
  end

  def export
    respond_to do | format |
      format.csv { render csv: @event.contacts, filename: @event.event_name,
    each_serializer: ContactSerializer, only: [ :last, :first, :role,
    :title, :work_phone], add_methods: [:school_name, :email,
    :subject] }
      format.json { render json: @event.contacts,
    each_serializer: ContactSerializer }
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Deleted Event: #{@event.event_name}"
    redirect_to Event
  end

  private
  def event_params
    params.require(:event).permit(:eventbrite_id, :event_name,
  :event_type, :series, :start_date, :end_date, :venue, :url,
  :description, :notes, :num_sessions)
  end

end
