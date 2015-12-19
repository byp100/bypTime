class ChaptersController < ApplicationController
  def index
    @chapters = Chapter.all
  end

  def show
    @events = @chapter.events.order(start_time: :desc).page(params[:page]).per_page 5
    @users = @chapter.users
  end
end
