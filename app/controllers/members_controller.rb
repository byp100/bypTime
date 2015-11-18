class MembersController < InheritedResources::Base
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_filter :verify_member, only: [:show, :edit, :update, :destroy]

  def create_attendee
    @event = Event.find params[:event_id]
    redirect_to root_path and return unless @event
    @attendance = Attendance.new
    if current_member?
      @member = current_member
      if Attendance.where(member: @member, event: @event).empty?
        Attendance.create(member: @member, event: @event)
        flash[:notice] = 'Thanks for signing up!'
      else
        flash[:notice] = 'Member already signed up'
      end
      redirect_to event_path @event
    else
      redirect_to new_member_session_path
    end
  end

  def check_in
    @event = Event.find params[:event_id]
    @attendee = Member.find params[:id]
    attendance = @attendee.attendances.find_by(event_id: @event.id)
    attendance.update_attributes(in_attendance: params[:check_in])
    redirect_to :back, notice: "#{@attendee.name} is in attendance"
  end

  private

    def set_member
      @member = Member.find(params[:id])
    end

    def verify_member
      unless member_signed_in? && current_member == @member
        flash[:notice] = 'You are not authorized to view this page'
        redirect_to new_member_session_path
      end
    end

    def member_params
      params.require(:member).permit(:name, :phone, :email, :birthdate, :occupation, :nickname, :native_city, :gender, :preferred_pronouns, :sexual_orientation, :home_phone, :student, :join_date, :committee_membership, :superpowers, :twitter, :facebook, :instagram, :education_level, :children, :partnership_status, :income, :household_size, :dietary_restriction, :immigrant, :country_of_origin, :password, :password_confirmation)
    end
end
