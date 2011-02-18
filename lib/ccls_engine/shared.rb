class Shared < ActiveRecord::Base
	use_db :prefix => "shared_"
	self.abstract_class = true
end
