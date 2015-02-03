class AttendeesController < ApplicationController
  load_and_authorize_resource except: [:create]

  def destroy
    @attendee.destroy
    flash[:notice] = "Removed Attendee #{@attendee.contact.full_name}"
    redirect_to edit_event_path(@attendee.event)
  end
end
