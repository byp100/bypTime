class EventsController < InheritedResources::Base

  def index
    @events = Event.where("start_time > ?", DateTime.now).order(start_time: :desc).page(params[:page]).per_page 5
  end

  def all
    @events = Event.all.order(start_time: :desc)
  end

  def unattend
    @event = Event.find params[:event_id]
    @attendee = User.find params[:attendee_id]
    attendance = @attendee.attendances.find_by(event_id: @event.id)
    attendance.destroy if attendance
    redirect_to :back, notice: 'You are no longer attending this event'
  end

  def import_events
    Event.import params[:event_file]
    redirect_to :back, notice: 'Event data has been imported'
  end

  def import_attendances
    Attendance.import params[:attendance_file]
    redirect_to :back, notice: 'Attendance data has been imported'
  end


  private

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :address, :event_type)
    end
end

