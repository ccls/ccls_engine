class CreateUsers < ActiveRecord::Migration
	def self.up
		create_table :users do |t|
			t.string :uid
			t.string :sn
			t.string :displayname
			t.string :mail, :default => '', :null => false
			t.string :telephonenumber
#			t.string :role_name
#
#			t.string :username
#			t.string :email, :default => '', :null => false
#			t.string :crypted_password
#			t.string :password_salt
#			t.string :persistence_token
#			t.string :perishable_token
#			t.integer :failed_login_count, :default => 0

			t.timestamps
		end
		add_index :users, :uid, :unique => true
		add_index :users, :sn
#		add_index :users, :role_name
#		add_index :users, :username, :unique => true
#		add_index :users, :email, :unique => true
#		add_index :users, :persistence_token, :unique => true
#		add_index :users, :perishable_token, :unique => true
	end

	def self.down
		drop_table :users
	end
end
