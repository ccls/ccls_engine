class County < Shared
	validates_presence_of( :name )
	validates_presence_of( :state_abbrev )

	validates_length_of( :name, :maximum => 250 )
	validates_length_of( :state_abbrev, :maximum => 2 )
	validates_length_of( :fips_code, :maximum => 4, :allow_nil => true )
end
