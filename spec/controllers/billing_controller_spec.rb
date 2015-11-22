require 'rails_helper'

RSpec.describe BillingController, type: :controller do

  describe "GET #edit" do
    it "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update_card" do
    it "returns http success" do
      get :update_card
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #update_contact" do
    it "returns http success" do
      get :update_contact
      expect(response).to have_http_status(:success)
    end
  end

end
