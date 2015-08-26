class MembersController < ApplicationController
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

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

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
        flash[:notice] = 'Thanks for signing up!'
      else
        flash[:notice] = 'Member already signed up'
      end
      redirect_to event_path @event
    else
      redirect_to new_member_session_path
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_in
    @event = Event.find params[:event_id]
    @attendee = Member.find params[:id]
    attendance = @attendee.attendances.find_by(event_id: @event.id)
    attendance.update_attributes(in_attendance: params[:check_in])
    redirect_to :back, notice: "#{@attendee.name} is in attendance"
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    def verify_member
      unless member_signed_in? && current_member == @member
        # flash[:notice] = 'You are not authorized to view this page'
        redirect_to new_member_session_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:name, :phone, :email, :birthdate, :occupation, :password, :password_confirmation)
    end
end
