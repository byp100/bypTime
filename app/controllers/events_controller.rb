class EventsController < InheritedResources::Base
  def show
    @event = @chapter.events.find params[:id]
  end

  def create
    @event = Event.new(event_params)
    # require 'pry'; binding.pry

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def unattend
    @event = Event.find params[:event_id]
    @attendee = User.find params[:attendee_id]
    attendance = @attendee.attendances.find_by(event_id: @event.id)
    attendance.destroy if attendance
    redirect_to :back, notice: 'You are no longer attending this event'
  end

  private

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :address, :event_type, :chapter_id)
    end
end

