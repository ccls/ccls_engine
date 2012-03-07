#	==	requires
#	*	study_subject_id
#	*	unit_id
class Sample < ActiveRecordShared

	belongs_to :aliquot_sample_format
	belongs_to :sample_type
	belongs_to :study_subject
	belongs_to :organization, :foreign_key => 'location_id'
	belongs_to :unit
	has_many :aliquots
	has_and_belongs_to_many :projects
	has_one :sample_kit
	accepts_nested_attributes_for :sample_kit

	named_scope :pending, :conditions => {
		:received_by_ccls_at => nil }
		
	named_scope :collected, :conditions => [
		'received_by_ccls_at IS NOT NULL' ]

	validates_presence_of :sample_type_id
	validates_presence_of :sample_type, :if => :sample_type_id
	validates_presence_of :study_subject_id
	validates_presence_of :study_subject, :if => :study_subject_id

	validates_presence_of :sent_to_subject_on,  :if => :collected_at
	validates_presence_of :collected_at,        :if => :received_by_ccls_at
	validates_presence_of :location_id,         :if => :sent_to_lab_on
	validates_presence_of :received_by_ccls_at, :if => :sent_to_lab_on
	validates_presence_of :sent_to_lab_on,      :if => :received_by_lab_on
	validates_presence_of :received_by_lab_on,  :if => :aliquotted_on

	#	NOTE I'm not sure how this validation will work for datetimes.
	validates_complete_date_for :sent_to_subject_on,   :allow_nil => true
	validates_complete_date_for :collected_at,         :allow_nil => true
	validates_complete_date_for :received_by_ccls_at,  :allow_nil => true
	validates_complete_date_for :sent_to_lab_on,       :allow_nil => true
	validates_complete_date_for :received_by_lab_on,   :allow_nil => true
	validates_complete_date_for :aliquotted_on,        :allow_nil => true
	validates_complete_date_for :receipt_confirmed_on, :allow_nil => true

	validates_past_date_for :sent_to_subject_on
	validates_past_date_for :collected_at
	validates_past_date_for :received_by_ccls_at
	validates_past_date_for :sent_to_lab_on
	validates_past_date_for :received_by_lab_on
	validates_past_date_for :aliquotted_on
	validates_past_date_for :receipt_confirmed_on

	validate :date_chronology

	#	Returns the parent of this sample type
	def sample_type_parent
		sample_type.parent
	end

	before_save :update_sample_outcome

protected

	def date_chronology
		errors.add(:collected_at,        "must be after sent_to_subject_on"
			) if collected_at_is_before_sent_to_subject_on?
		errors.add(:received_by_ccls_at, "must be after collected_at"
			) if received_by_ccls_at_is_before_collected_at?
		errors.add(:sent_to_lab_on,      "must be after received_by_ccls_at"
			) if sent_to_lab_on_is_before_received_by_ccls_at?
		errors.add(:received_by_lab_on,  "must be after sent_to_lab_on"
			) if received_by_lab_on_is_before_sent_to_lab_on?
		errors.add(:aliquotted_on,       "must be after received_by_lab_on"
			) if aliquotted_on_is_before_received_by_lab_on?
	end

	def collected_at_is_before_sent_to_subject_on?
		(( sent_to_subject_on && collected_at ) &&
			( sent_to_subject_on >  collected_at ))
	end

	def received_by_ccls_at_is_before_collected_at?
		(( collected_at && received_by_ccls_at ) &&
			( collected_at >  received_by_ccls_at ))
	end

	def sent_to_lab_on_is_before_received_by_ccls_at?
		(( received_by_ccls_at && sent_to_lab_on ) &&
			( received_by_ccls_at >  sent_to_lab_on ))
	end

	def received_by_lab_on_is_before_sent_to_lab_on?
		(( sent_to_lab_on && received_by_lab_on ) &&
			( sent_to_lab_on >  received_by_lab_on ))
	end

	def aliquotted_on_is_before_received_by_lab_on?
		(( received_by_lab_on && aliquotted_on ) &&
			( received_by_lab_on >  aliquotted_on ))
	end

	def update_sample_outcome
		if study_subject.enrollments.find_by_project_id(Project['HomeExposures'].id)
			ho = study_subject.homex_outcome || study_subject.create_homex_outcome
			so,date = if sent_to_lab_on_changed? && !sent_to_lab_on.nil?
				[SampleOutcome['lab'], sent_to_lab_on ]
			elsif received_by_ccls_at_changed? && !received_by_ccls_at.nil?
				[SampleOutcome['received'], received_by_ccls_at ]
			elsif sent_to_subject_on_changed? && !sent_to_subject_on.nil?
				[SampleOutcome['sent'], sent_to_subject_on ]
			end
			ho.update_attributes({
				:sample_outcome => so,
				:sample_outcome_on => date }) if so
		end
	end

end
