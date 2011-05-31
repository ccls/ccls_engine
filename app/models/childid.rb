class Childid < Shared
#	TODO add some documentation here once this is to be used

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
