class Membership < ActiveRecord::Base
	belongs_to :organization
	belongs_to :member, class_name: "User", foreign_key: "user_id"
end
