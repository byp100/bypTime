require 'rails_helper'
require_relative 'controller_helper'

describe MembersController do
  describe 'GET #index' do
    it 'populates the array of members' do
      member = create :member
      get :index
      assigns(:members).should eq [member]
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested member to @member' do
      member = create :member
      get :show, id: member
      assigns(:member).should eq member
    end

    it 'renders the :show view' do
      member = create :member
      member_logged_in! member
      get :show, id: member
      response.should render_template :show
    end

    it 'redirects to sign in page if not logged in' do
      member = create :member
      get :show, id: member
      response.should redirect_to new_member_session_path
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates the member' do
        post :create, member: attributes_for(:member)
        expect(Member.count).to eq 1
      end

      it 'redirects to the show action for the new member' do
        post :create, member: attributes_for(:member)
        expect(response).to redirect_to Member.last
      end
    end

    context 'with invalid attributes' do
      it 'does not create the member' do
        post :create, member: attributes_for(:member, name: nil)
        expect(Member.count).to eq 0
      end

      it 're renders the new view' do
        post :create, member: attributes_for(:member, name: nil)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @member = create :member
      member_logged_in! @member
    end

    context 'valid attributes' do
      it 'locates the requested member' do
        put :update, id: @member, member: attributes_for(:member)
        assigns(:member).should eq @member
      end

      it 'changes the members attributes' do
        put :update, id: @member, member: attributes_for(:member, name: 'Assata Shakur', phone: '6465551000')
        @member.reload

        expect(@member.name).to eq 'Assata Shakur'
        expect(@member.phone).to eq '6465551000'
      end

      it 'redirects to the updated member' do
        put :update, id: @member, member: attributes_for(:member, name: 'Assata Shakur', phone: '6465551000')
        expect(response).to redirect_to @member
      end
    end

    context 'invalid attributes' do
      it 'locates the requested member' do
        put :update, id: @member, member: attributes_for(:member, name: nil)
        assigns(:member).should eq @member
      end

      it 'does not change the members attributes' do
        put :update, id: @member, member: attributes_for(:member, name: nil, phone: '6465551000')
        @member.reload

        expect(@member.phone).to_not eq '6465551000'
      end

      it 're renders the edit template' do
        put :update, id: @member, member: attributes_for(:member, name: nil, phone: '6465551000')
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @member = create :member
    end

    it 'deletes the member' do
      delete :destroy, id: @member
      expect(Event.count).to eq 0
    end

    it 'redirects to the members index' do
      delete :destroy, id: @member
      expect(response).to redirect_to new_member_session_path #change this
    end
  end

  describe 'POST #create_attendee' do
    it 'creates an attendance' do
      member_logged_in!
      event = create :event
      post :create_attendee, event_id: event.id
      expect(Attendance.count).to eq 1
    end

    it 'redirects to the event page after creating the attendance' do
      member_logged_in!
      event = create :event
      post :create_attendee, event_id: event.id
      expect(response).to redirect_to event
    end

    it 'does not create attendance if not logged in' do
      event = create :event
      post :create_attendee, event_id: event.id
      expect(Attendance.count).to eq 0
    end

    it 'redirects to sign in page if not logged in' do
      event = create :event
      post :create_attendee, event_id: event.id
      expect(response).to redirect_to new_member_session_path
    end

    it 'does not create attendance if one already exists' do
      member = create :member
      event = create :event
      event.attendees << member
      member_logged_in! member
      expect(Attendance.count).to eq 1

      post :create_attendee, event_id: event.id
      expect(Attendance.count).to eq 1
    end
  end

  describe 'PUT #check_in' do
    it 'updates the attendance to be checked in' do
      request.env['HTTP_REFERER'] = root_path

      event = create :event
      member = create :member
      event.attendees << member

      put :check_in, event_id: event.id, id: member.id, check_in: true

      expect(Attendance.last.in_attendance).to eq true
    end

    it 'updates the attendance to not be checked in' do
      request.env['HTTP_REFERER'] = root_path

      event = create :event
      member = create :member
      event.attendees << member

      put :check_in, event_id: event.id, id: member.id, check_in: false

      expect(Attendance.last.in_attendance).to eq false
    end
  end
end