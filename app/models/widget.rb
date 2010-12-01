class Widget < ActiveRecord::Base
	use_db :prefix => "shared_"
	belongs_to :maker
end
