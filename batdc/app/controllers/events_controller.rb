class EventsController < ApplicationController
  load_and_authorize_resource except: [:create]

  def index
    if params[:search]
      filt = "event_name like ?"
      srch = "%#{params[:search]}%"
      pag = { page: params[:page], per_page: 25}
      @events = Event.where(filt, srch).order(:start_date).paginate(pag)
    else
      @events = Event.order(start_date: :desc).paginate(page: params[:page],
    per_page: 25)
    end
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
  
  private
  def event_params
    params.require(:event).permit(:eventbrite_id, :event_name,
  :event_type, :series, :start_date, :end_date, :venue, :url,
  :description, :notes, :num_sessions)
  end

end
