class UsersController < InheritedResources::Base
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :verify_user, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.find(params[:event_id])
    if @event.event_type == "orientation"
      @user = User.new
    else
      redirect_to event_path(@event), notice: "Sorry, you cannot join BYP with this type of event."
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.create(user_params)
    Membership.create(organization_id: current_tenant.id, member_id: @user.id)
    Membership.create(organization_id: Organization.find_by(slug: "www").id, member_id: @user.id)

    if params[:event_id].present?
      @event = Event.find(params[:event_id])
      Attendance.create(user: @user, event: @event)
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'user was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_attendee
    @event = Event.find params[:event_id]
    redirect_to root_path and return unless @event
    @attendance = Attendance.new
    if current_user?
      @user = current_user
      if Attendance.where(user: @user, event: @event).empty?
        Attendance.create(user: @user, event: @event)
        if @user.eligible_for_membership?
          @user.begin_enrollment
        end
        flash[:notice] = 'Thanks for signing up!'
      else
        flash[:notice] = 'user already signed up'
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
