class EventsController < ApplicationController
  def new
  end

  def show
    @event = Event.find params[:id]
  end

  def index
    @events = Event.all
  end

  def create
    @event = Event.new(event_params)

    @event.save
    redirect_to @event
  end

  private

    def event_params
      params.require(:event).permit(:title, :description)
    end
end
