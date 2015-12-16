class UsersController < InheritedResources::Base
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :verify_user, only: [:show, :edit, :update, :destroy]

  def create_attendee
    @event = Event.find params[:event_id]
    redirect_to root_path and return unless @event
    @attendance = Attendance.new
    if current_user?
      user = current_user
      if Attendance.where(user: user, event: @event).empty?
        Attendance.create(user: user, event: @event)
        flash[:notice] = 'Thanks for signing up!'
      else
        flash[:notice] = 'User already signed up'
      end
      redirect_to event_path @event
    else
      redirect_to new_user_session_path
    end
  end

  def check_in
    @event = Event.find params[:event_id]
    @attendee = User.find params[:user_id]
    attendance = @attendee.attendances.find_by(event_id: @event.id)
    attendance.update_attributes(in_attendance: params[:check_in])
    redirect_to :back, notice: "#{@attendee.name} is in attendance"
  end

  def import
    User.import params[:user_file]
    redirect_to :back, notice: 'User data has been imported'
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def verify_user
      unless user_signed_in? && current_user == @user
        flash[:notice] = 'You are not authorized to view this page'
        redirect_to new_user_session_path
      end
    end

    def user_params
      params.require(:user).permit(:name, :phone, :email, :birthdate, :occupation, :nickname, :native_city, :gender, :preferred_pronouns, :sexual_orientation, :home_phone, :student, :join_date, :committee_membership, :superpowers, :twitter, :facebook, :instagram, :education_level, :children, :partnership_status, :income, :household_size, :dietary_restriction, :immigrant, :country_of_origin, :password, :password_confirmation)
    end
end
