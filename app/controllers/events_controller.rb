class EventsController < InheritedResources::Base

  def unattend
    @event = Event.find params[:event_id]
    @attendee = Member.find params[:attendee_id]
    attendance = @attendee.attendances.find_by(event_id: @event.id)
    attendance.destroy if attendance
    redirect_to :back, notice: 'You are no longer attending this event'
  end

  private

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :address, :event_type)
    end
end

