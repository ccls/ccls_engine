class AddCalnetAuthenticatedColumnsToUsers < ActiveRecord::Migration
	def self.up
		table_name = 'users'
		create_table table_name do |t|
			t.timestamps
		end unless table_exists?(table_name)
		cols = columns(table_name).map(&:name)
		add_column( table_name, :uid, :string 
			) unless cols.include?('uid')
		add_column( table_name, :sn, :string 
			) unless cols.include?('sn')
		add_column( table_name, :displayname, :string 
			) unless cols.include?('displayname')
		add_column( table_name, :mail, :string, { 
				:default => '', :null => false } 
			) unless cols.include?('mail')
		add_column( table_name, :telephonenumber, :string 
			) unless cols.include?('telephonenumber')

		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :uid, :unique => true 
			) unless idxs.include?("index_#{table_name}_on_uid")
		add_index( table_name, :sn 
			) unless idxs.include?("index_#{table_name}_on_sn")
	end

	def self.down
		table_name = 'users'
		remove_index  table_name, :uid
		remove_index  table_name, :sn 
		remove_column table_name, :uid
		remove_column table_name, :sn
		remove_column table_name, :displayname
		remove_column table_name, :mail
		remove_column table_name, :telephonenumber
	end
end
