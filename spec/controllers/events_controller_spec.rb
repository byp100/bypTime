require 'rails_helper'
require_relative 'controller_helper'

describe EventsController do
  before :each do
    User.destroy_all
    Event.destroy_all
    user_logged_in! create :user
  end

  describe 'GET #index' do
    it 'populates with all future events' do
      event = create :event, start_time: Time.now + 2.days
      past_event = create :event, start_time: Time.now - 2.days
      get :index
      assigns(:events).should eq [event]
    end

    it 'lists events in ascending order' do
      event_tomorrow = create :event, start_time: Time.now + 1.day
      event_next_week = create :event, start_time: Time.now + 8.days
      get :index
      assigns(:events).should eq [event_tomorrow, event_next_week]
    end

    it 'renders the :index view' do
      get :index
      response.should render_template :index
    end
  end

  describe 'GET #past_events' do
    it 'populates with all past events' do
      event = create :event, start_time: Time.now + 2.days
      past_event = create :event, start_time: Time.now - 2.days
      get :past_events
      assigns(:past_events).should eq [past_event]
    end

    it 'lists events in descending order' do
      event_yesterday = create :event, start_time: Time.now - 1.day
      event_a_week_ago = create :event, start_time: Time.now - 8.days
      get :past_events
      assigns(:past_events).should eq [event_yesterday, event_a_week_ago]
    end

    it 'renders the :past_events view' do
      get :past_events
      response.should render_template :past_events
    end
  end

  describe 'GET #show' do
    it 'assigns the requested event to @event' do
      event = create :event
      get :show, id: event
      assigns(:event).should eq event
    end

    it 'renders the :show view' do
      get :show, id: create(:event)
      response.should render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      response.should render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new event to the database' do
        post :create, event: attributes_for(:event)
        expect(Event.count).to eq 1
      end

      it 'redirects to the homepage' do
        post :create, event: attributes_for(:event)
        response.should redirect_to Event.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new event to the database' do
        post :create, event: attributes_for(:event, title: nil)
        expect(Event.count).to eq 0
      end

      it 're renders the :new template' do
        post :create, event: attributes_for(:event, title: nil)
        response.should render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @event = create :event
    end

    context 'valid attributes' do
      it 'locates the requested event' do
        put :update, id: @event, event: attributes_for(:event)
        assigns(:event).should eq @event
      end

      it 'changes the events attributes' do
        put :update, id: @event, event: attributes_for(:event, title: 'Public Protest', event_type: :public_event)
        @event.reload

        expect(@event.title).to eq 'Public Protest'
        expect(@event.event_type).to eq 'public_event'
      end

      it 'redirects to the updated event' do
        put :update, id: @event, event: attributes_for(:event, title: 'Public Protest', event_type: :public_event)
        expect(response).to redirect_to @event
      end
    end

    context 'invalid attributes' do
      it 'locates the requested event' do
        put :update, id: @event, event: attributes_for(:event, title: nil)
        assigns(:event).should eq @event
      end

      it 'does not change the events attributes' do
        put :update, id: @event, event: attributes_for(:event, title: 'Public Protest', event_type: :public_event, start_time: nil)
        @event.reload

        expect(@event.title).to_not eq 'Public Protest'
        expect(@event.event_type).to_not eq 'public_event'
      end

      it 're renders the edit template' do
        put :update, id: @event, event: attributes_for(:event, title: 'Public Protest', event_type: :public_event, start_time: nil)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @event = create :event
    end

    it 'deletes the event' do
      delete :destroy, id: @event
      expect(Event.count).to eq 0
    end

    it 'redirects to the events index' do
      delete :destroy, id: @event
      expect(response).to redirect_to events_path
    end
  end

  describe 'PUT #unattend' do
    it 'should remove the attendance from the user and the event' do
      request.env['HTTP_REFERER'] = root_path

      event = create :event
      user = create :user
      event.attendees << user

      put :unattend, event_id: event.id, attendee_id: user.id

      expect(Attendance.count).to eq 0
    end
  end
end