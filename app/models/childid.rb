#
#	I am removing this due to its issues.
#
class Childid < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
#	TODO add some documentation here once this is to be used


#	This stuff is used just for testing as these are created and destroyed
#	so in order to test that one was taken, I need to check the next_id.
#	This can all be removed if and when this technique is replaced
#	with something that does not destroy.  The tests will also need
#	modified to check the count.

	class << self
		#	This is MySQL specific and therefore not explicitly tested.
		def table_status
			r=self.connection.execute("show table status where name = '#{self.table_name}'")
			r.fetch_hash
		end

		#This is MySQL specific and therefore not explicitly tested.
		def auto_increment
			self.table_status['Auto_increment'].to_i
		end
		alias_method :next_id, :auto_increment
	end

end
