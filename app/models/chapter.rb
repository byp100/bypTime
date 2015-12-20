class Chapter < Organization
	belongs_to :owner, class_name: "Organization"
end