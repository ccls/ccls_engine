class LiveBirthData < ActiveRecordShared

	has_attached_file :csv_file,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/live_birth_data.yml')
		))).result)[Rails.env]

end
