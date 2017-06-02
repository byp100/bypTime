class UsersController < InheritedResources::Base
  before_filter :authenticate_user!
  # after_action :verify_authorized

  def index
    if current_tenant.present?
      @users = User.where(id: User.joins(:memberships).where(memberships: {organization_id: current_tenant.id}).to_a.uniq.map{|u| u.id})
    else
      @users = User.all
    end
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(user_params)
      redirect_to @user, :notice => "User updated."
    else
      redirect_to @user, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def create_attendee
    @event = Event.find params[:event_id]
    redirect_to root_path and return unless @event
    @attendance = Attendance.new

    if Attendance.where(user: current_user, event: @event).empty?
      Attendance.create(user: current_user, event: @event)
      flash[:notice] = 'Thanks for signing up!'
    else
      flash[:notice] = 'User already signed up'
    end
    redirect_to event_path @event
  end

  def create_with_access_code
    @event = Event.find(params[:event_id])
    if params[:code] == @event.access_code
      @user = User.create(user_params)
      Membership.create(organization_id: ActsAsTenant.current_tenant.id, member_id: @user.id)
      Membership.create(organization_id: Organization.find_by(slug: "www").id, member_id: @user.id)

      Attendance.create(user: @user, event: @event)

      respond_to do |format|
        if @user.save
          format.html { redirect_to root_path, notice: "#{@user.name}'s account was successfully created. Please login to access the event." }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: 'Unable to create user. Invalid access code'
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
    User.import(params[:user_file], current_tenant)
    redirect_to :admin_dashboard, notice: 'User data has been imported'
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :birthdate, :occupation, :nickname, :native_city, :gender, :preferred_pronouns, :sexual_orientation, :home_phone, :student, :join_date, :committee_membership, :superpowers, :twitter, :facebook, :instagram, :education_level, :children, :partnership_status, :income, :household_size, :dietary_restriction, :immigrant, :country_of_origin, :password, :password_confirmation)
  end
end