class MembersController < InheritedResources::Base
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_filter :verify_member, only: [:show, :edit, :update, :destroy]

  # GET /members
  # GET /members.json
  def index
    @members = Member.all
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  def new
    @event = Event.find(params[:event_id])
    if @event.event_type == "orientation"
      @member = Member.new
    else
      redirect_to event_path(@event), notice: "Sorry, you cannot join BYP with this type of event."
    end
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.create(member_params)
    @member.memberships.create(organization_id: current_tenant.id)
    @member.memberships.create(organization_id: Organization.find_by(slug: "www").id)

    if params[:event_id].present?
      @event = Event.find(params[:event_id])
      Attendance.create(member: @member, event: @event)
    end

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_attendee
    @event = Event.find params[:event_id]
    redirect_to root_path and return unless @event
    @attendance = Attendance.new
    if current_member?
      @member = current_member
      if Attendance.where(member: @member, event: @event).empty?
        Attendance.create(member: @member, event: @event)
        if @member.eligible_for_membership?
          @member.begin_enrollment
        end
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
