require 'rails_helper'
require_relative 'controller_helper'

describe UsersController do
  before :each do
    User.destroy_all
    Event.destroy_all
  end

  describe 'GET #index' do
    it 'populates the array of users' do
      user = create :user
      admin = create :user, :admin
      user_logged_in! admin
      get :index
      assigns(:users).should eq [user, admin]
    end

    it 'renders the :index view' do
      user_logged_in! create(:user, :admin)
      get :index
      response.should render_template :index
    end
  end

  describe 'GET #new' do
    it 'assigns the requested event to @event' do
      event = create :event, :orientation, :access_code
      user_logged_in! create(:user, :admin)
      get :new, event_id: event, code: '4422'
      assigns(:event).should eq event
    end

    context 'wrong access code' do
      it 'redirects to the event with error message' do
        event = create :event, :orientation, :access_code
        user_logged_in! create(:user, :admin)

        get :new, event_id: event, code: '1234'

        expect(response).to redirect_to event
        expect(flash[:error]).to eq 'Invalid access code'
      end
    end

    context 'wrong event type' do
      it 'redirects to the event with error message' do
        event = create :event, :public_event, :access_code
        user_logged_in! create(:user, :admin)

        get :new, event_id: event, code: '4422'

        expect(response).to redirect_to event
        expect(flash[:error]).to eq 'Sorry, you cannot join BYP with this type of event.'
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      user = create :user
      user_logged_in! create(:user, :admin)
      get :show, id: user
      assigns(:user).should eq user
    end

    it 'renders the :show view' do
      user = create :user
      user_logged_in! user
      get :show, id: user
      response.should render_template :show
    end

    it 'redirects to sign in page if not logged in' do
      user = create :user
      get :show, id: user
      response.should redirect_to new_user_session_path
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates the user' do
        user_logged_in! create(:user, :admin)
        post :create, user: attributes_for(:user)
        expect(User.count).to eq 2 # including logged in admin
      end

      it 'redirects to the show action for the new user' do
        user_logged_in! create(:user, :admin)
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to User.last
      end
    end

    context 'with invalid attributes' do
      it 'does not create the user' do
        post :create, user: attributes_for(:user, name: nil)
        expect(User.count).to eq 0
      end

      it 're renders the new view' do
        user_logged_in! create(:user, :admin)
        post :create, user: attributes_for(:user, name: nil)
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create_with_access_code' do
    context 'with valid access code' do
      it 'creates the user and an attendance' do
        organization = create :organization, slug: 'www'
        ActsAsTenant.current_tenant = organization
        event = create :event, :access_code
        user_logged_in! create(:user, :admin)

        post :create_with_access_code, code: '4422', user: attributes_for(:user), event_id: event.id
        expect(User.count).to eq 2 # including logged in admin
        expect(Attendance.count).to eq 1
      end
    end

    context 'with invalid access code' do
      it 'redirects to home page with error message' do
        organization = create :organization, slug: 'www'
        ActsAsTenant.current_tenant = organization
        event = create :event, :access_code
        user_logged_in! create(:user, :admin)

        post :create_with_access_code, code: '4425', user: attributes_for(:user), event_id: event.id
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq 'Unable to create user. Invalid access code'
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @user = create :user
      user_logged_in! @user
    end

    context 'valid attributes' do
      it 'locates the requested user' do
        put :update, id: @user, user: attributes_for(:user)
        assigns(:user).should eq @user
      end

      it 'changes the users attributes' do
        put :update, id: @user, user: attributes_for(:user, name: 'Assata Shakur', phone: '6465551000')
        @user.reload

        expect(@user.name).to eq 'Assata Shakur'
        expect(@user.phone).to eq '6465551000'
      end

      it 'redirects to the updated user' do
        put :update, id: @user, user: attributes_for(:user, name: 'Assata Shakur', phone: '6465551000')
        expect(response).to redirect_to @user
      end
    end

    context 'invalid attributes' do
      it 'locates the requested user' do
        put :update, id: @user, user: attributes_for(:user, name: nil)
        assigns(:user).should eq @user
      end

      it 'does not change the users attributes' do
        put :update, id: @user, user: attributes_for(:user, name: nil, phone: '6465551000')
        @user.reload

        expect(@user.phone).to_not eq '6465551000'
      end

      it 're renders the edit template' do
        put :update, id: @user, user: attributes_for(:user, name: nil, phone: '6465551000')
        expect(response).to redirect_to @user
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = create :user
    end

    it 'deletes the user' do
      delete :destroy, id: @user
      expect(Event.count).to eq 0
    end

    it 'redirects to the users index' do
      delete :destroy, id: @user
      expect(response).to redirect_to new_user_session_path #change this
    end
  end

  describe 'POST #create_attendee' do
    it 'creates an attendance' do
      user_logged_in!
      event = create :event
      post :create_attendee, event_id: event.id
      expect(Attendance.count).to eq 1
    end

    it 'redirects to the event page after creating the attendance' do
      user_logged_in!
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
      expect(response).to redirect_to new_user_session_path
    end

    it 'does not create attendance if one already exists' do
      user = create :user
      event = create :event
      event.attendees << user
      user_logged_in! user
      expect(Attendance.count).to eq 1

      post :create_attendee, event_id: event.id
      expect(Attendance.count).to eq 1
    end
  end

  describe 'PUT #check_in' do
    it 'updates the attendance to be checked in' do
      request.env['HTTP_REFERER'] = root_path

      event = create :event
      user = create :user
      user_logged_in! user
      event.attendees << user

      put :check_in, event_id: event.id, user_id: user.id, check_in: true

      expect(Attendance.last.in_attendance).to eq true
    end

    it 'updates the attendance to not be checked in' do
      request.env['HTTP_REFERER'] = root_path

      event = create :event
      user = create :user
      event.attendees << user

      put :check_in, event_id: event.id, user_id: user.id, check_in: false

      expect(Attendance.last.in_attendance).to eq false
    end
  end
end