class MainSite < Organization
	has_many :chapters, class_name: "Organization", foreign_key: "owner_id"
end