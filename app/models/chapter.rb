class Chapter < ActiveRecord::Base
  has_many :events
  has_many :users

  CHAPTERS = {
      'Chicago' => 'chi',
      'New York' => 'ny',
      'Washington DC' => 'dc'
  }
end
