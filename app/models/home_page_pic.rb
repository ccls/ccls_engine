# A picture used soley on the home page
class HomePagePic < Shared
	validates_presence_of :title
	validates_length_of :title, :in => 4..250

	has_attached_file :image,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(Rails.root,'config/home_page_pic.yml')
		))).result)[Rails.env]

#	class MissingAdapter < StandardError; end

	#	Return a randomly selected active HomePagePic
	def self.random_active
#		#	there should be a better way.  a rails way.
#		#	This will cause code to be untested.
#		random = case adapter()
#			when "mysql"   then "RAND()"
#			when "sqlite3" then "Random()"
#			else raise MissingAdapter
#		end
#		first( :order => random, :conditions => { :active => true } )
		conditions = [ 'active = ? AND image_file_name IS NOT NULL', true ]
		count = HomePagePic.count(:conditions => conditions )
		if count > 0
			first(:offset => rand(count), :conditions => conditions )
		else
			nil
		end
	end

protected

#	def self.adapter
#		could've used connection.adapter_name 
#		(but be careful as the CaSE isn't always the same for all rubies)
#		@adapter ||= connection.instance_variable_get(:@config)[:adapter]
#	end

end
