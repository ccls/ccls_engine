#
#	Due to the possibility of rails adding a class called ActiveRecord::Shared
#	I'm just going to name this ActiveRecordShared
#
class ActiveRecordShared < ActiveRecord::Base
	use_db :prefix => "shared_"
	self.abstract_class = true
end
