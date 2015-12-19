require 'spec_helper'

describe ChaptersController do
  before(:each) do
    @chapter = create :chapter, name: "Subdomain", subdomain: 'sub'
    @request.host = "sub.example.org"
  end

  describe 'GET: #index' do
    it 'populates the array of chapters' do
      get :index
      assigns(:chapters).should eq [@chapter]
    end
  end

  describe 'GET: #show' do
    it 'assigns the requested chapter' do

    end
  end

end
