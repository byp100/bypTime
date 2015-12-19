require 'controllers/controller_helper'

describe ApplicationController do
  describe '#get_chapter' do
    it 'should assign the correct chapter based on the request' do
      chapter = create :chapter, name: "Subdomain", subdomain: 'sub'
      @request.host = "sub.example.org"
      subject.send(:get_chapter)
      expect(assigns(:chapter)).to eq chapter
    end
  end
end