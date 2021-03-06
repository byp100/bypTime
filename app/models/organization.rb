class Organization < ActiveRecord::Base
	has_many :events
	has_many :memberships
	has_many :users, through: :memberships
	extend FriendlyId
  friendly_id :short_name, use: :slugged
end
