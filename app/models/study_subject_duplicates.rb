#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectDuplicates
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	#
	#	Basically this is just a custom search expecting only the 
	#	following possible params for search / comparison ...
	#
	#		mother_maiden_name
	#		hospital_no
	#		dob
	#		sex
	#		admit_date
	#		organization_id
	#
	#		Would want to explicitly exclude self, but this check is
	#		to be done BEFORE subject creation so won't actually
	#		have an id to use to exclude itself anyway.
	#
	#		For adding controls, will need to be able to exclude case
	#		so adding :exclude_id option somehow
	#
	def self.duplicates(params={})
		conditions = [[],{}]

		if params.has_key?(:hospital_no) and !params[:hospital_no].blank?
			conditions[0] << '(hospital_no = :hospital_no)'
			conditions[1][:hospital_no] = params[:hospital_no]
		end

		#	This is effectively the only test for adding controls
		#	as the other attributes are from the patient model
		#	which is only for cases.
		if params.has_key?(:dob) and !params[:dob].blank? and
				params.has_key?(:sex) and !params[:sex].blank? and 
				params.has_key?(:mother_maiden_name)
#	since remove nullify of name fields, added comparison to ""
			conditions[0] << '(dob = :dob AND sex = :sex AND ( mother_maiden_name IS NULL OR mother_maiden_name = "" OR mother_maiden_name = :mother_maiden_name ))'
			conditions[1][:dob] = params[:dob]
			conditions[1][:sex] = params[:sex]
			#	added to_s as may be null so sql is valid and has '' rather than a blank
			conditions[1][:mother_maiden_name] = params[:mother_maiden_name].to_s		
		end
		if params.has_key?(:admit_date) and !params[:admit_date].blank? and
				params.has_key?(:organization_id) and !params[:organization_id].blank?
			conditions[0] << '(admit_date = :admit AND organization_id = :org)'
			conditions[1][:admit] = params[:admit_date]
			conditions[1][:org] = params[:organization_id]
		end

		unless conditions[0].blank?
			conditions_array = [ "(#{conditions[0].join(' OR ')})" ]
			if params.has_key?(:exclude_id)
				conditions_array[0] << " AND study_subjects.id != :exclude_id"
				conditions[1][:exclude_id] = params[:exclude_id]
			end
			conditions_array << conditions[1]
#puts conditions_array.inspect
#["((hospital_no = :hospital_no) OR (dob = :dob AND sex = :sex AND ( mother_maiden_name IS NULL OR mother_maiden_name = :mother_maiden_name )) OR (admit_date = :admit AND organization_id = :org)) AND study_subjects.id != :exclude_id", {:hospital_no=>"matchthis", :org=>31, :admit=>Wed, 16 Nov 2011, :sex=>"F", :exclude_id=>3, :mother_maiden_name=>"", :dob=>Wed, 16 Nov 2011}]

			find(:all,
				#	have to do a LEFT JOIN, not the default INNER JOIN, here
				#			:joins => [:pii,:patient,:identifier]
				#	otherwise would only include subjects with pii, patient and identifier,
				#	which would effectively exclude controls. (maybe that's ok?. NOT OK.)
				:joins => [
					'LEFT JOIN patients ON study_subjects.id = patients.study_subject_id'
				],
				:conditions => conditions_array
			) 
		else
			[]
		end
	end

	def duplicates(options={})
		self.class.duplicates({
			:mother_maiden_name => self.mother_maiden_name,
			:hospital_no => self.hospital_no,
			:dob => self.dob,
			:sex => self.sex,
			:admit_date => self.admit_date,
			:organization_id => self.organization_id
		}.merge(options))
	end

	def raf_duplicate_creation_attempted(attempted_subject)
		ccls_enrollment = enrollments.find_or_create_by_project_id(Project['ccls'].id)
		OperationalEvent.create!(
			:enrollment => ccls_enrollment,
			:operational_event_type => OperationalEventType['DuplicateCase'],
			:occurred_on            => Date.today,
			:description            => "a new RAF for this subject was submitted by " <<
				"#{attempted_subject.admitting_oncologist} of " <<
				"#{attempted_subject.organization} " <<
				"with hospital number: " <<
				"#{attempted_subject.hospital_no}."
		)
	end

end	#	class_eval
end	#	included
end	#	StudySubjectDuplicates
__END__
