class Widget < ActiveRecord::Base
	use_db :prefix => "shared_"
end
