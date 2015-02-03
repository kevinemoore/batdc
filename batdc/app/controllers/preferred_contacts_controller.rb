class PreferredContactsController < ApplicationController
  load_and_authorize_resource except: [:create]
  
  def destroy
    @preferred_contact.destroy
    fn = @preferred_contact.contact.full_name
    s = @preferred_contact.school.name
    flash[:notice] = "#{fn} is no longer a preferred contact for #{s}"
    redirect_to edit_school_path(@preferred_contact.school)
  end
end
