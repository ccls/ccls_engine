# This has gotton out of control.  While it certainly still functions,
#	I would advise that search commands be a bit more concise as most
#	are only used in one location.
class StudySubjectSearch < Search

	self.searchable_attributes += [ :races, :types, :vital_statuses, :q,
		:sample_outcome, :interview_outcome,
		:projects, :has_gift_card, :patid,
		:abstracts_count
	]

	self.attr_accessors += [ :search_gift_cards, :abstracts_count ]

#	self.valid_orders.merge!({  #	NO!
#	@valid_orders.merge!({      #	NO!
	self.valid_orders = self.valid_orders.merge({
		:id => 'study_subjects.id',	#	must remove any possible ambiguity
		:childid => 'identifiers.childid',
#		:last_name => 'piis.last_name',
#		:first_name => 'piis.first_name',
#		:dob => 'piis.dob',
		:last_name => 'last_name',
		:first_name => 'first_name',
		:dob => 'dob',
		:studyid => 'identifiers.patid',
		:priority => 'recruitment_priority',
		:sample_outcome => 'homex_outcomes.sample_outcome_id',
		:sample_outcome_on => 'homex_outcomes.sample_outcome_on',
		:patid => 'identifiers.patid',
		:abstracts_count => nil,
		:interview_outcome_on => 'homex_outcomes.interview_outcome_on',
		:sample_sent_on => nil,
		:sample_received_on => nil,
		:number => 'gift_cards.number',
		:issued_on => 'gift_cards.issued_on',
		:sent_to_subject_on => 'samples.sent_to_subject_on',
		:received_by_ccls_on => 'samples.received_by_ccls_on'
	})

	def study_subjects
#		require_dependency 'pii.rb'	unless Pii
		require_dependency 'identifier.rb' unless Identifier
		require_dependency 'gift_card.rb' unless GiftCard
		@subjects ||= StudySubject.send(
			(paginate?)?'paginate':'all',{
#				:include => [:pii,:identifier],
				:include => [:identifier],
				:select  => select,
				:group   => group,
				:having  => having,
				:order   => search_order,
				:joins   => joins,
				:conditions => conditions
			}.merge(
				(paginate?)?{
					:per_page => per_page||25,
					:page     => page||1
				}:{}
			)
		)
	end
	alias_method :subjects, :study_subjects

private	#	THIS IS REQUIRED

	def samples_joins
		"JOIN samples ON study_subjects.id " <<
			"= samples.study_subject_id" if %w( sent_to_subject_on received_by_ccls_on ).include?(@order)
	end

	def vital_statuses_joins
		"INNER JOIN vital_statuses ON vital_statuses.id " <<
			"= study_subjects.vital_status_id" unless vital_statuses.blank?
	end

	def vital_statuses_conditions
		['vital_statuses.code IN (:vital_statuses)', { :vital_statuses => vital_statuses }
			] unless vital_statuses.blank?
	end

	def patid_conditions
		['identifiers.patid = :patid', {:patid => patid}] unless patid.blank?
	end


	def races_joins
#		"INNER JOIN races ON races.id = study_subjects.race_id" unless races.blank?
		"LEFT JOIN subject_races ON study_subjects.id = subject_races.study_subject_id LEFT JOIN races ON races.id = subject_races.race_id" unless races.blank?
	end

#>> study_subjects = StudySubject.find(:all, :joins => "left join samples on study_subjects.id = samples.study_subject_id", :group => 'study_subjects.id', :having => ["sample_ids LIKE '%?%'",1], :select => "study_subjects.id, GROUP_CONCAT(samples.id) as sample_ids")
#=> [#<StudySubject id: 1>, #<StudySubject id: 2014>]

	def races_groups
		'study_subjects.id' unless races.blank?
	end
	
	def races_selects
		"study_subjects.*, CONCAT('|',GROUP_CONCAT(races.description SEPARATOR '|'),'|') as race_descriptions" unless races.blank?
	end

	def races_havings
		unless races.blank?
			c = []
			v = {}
			races.each_with_index do |race,i|
				c << "race_descriptions LIKE :r#{i}"
				v["r#{i}".to_sym] = "%|#{race}|%"
			end
			[ c.join(' OR '), v ]
		end
	end


	def types_joins
		"INNER JOIN subject_types ON subject_types.id " <<
			"= study_subjects.subject_type_id" unless types.blank?
	end

	def types_conditions
		['subject_types.description IN (:types)', { :types => types }
			] unless types.blank?
	end

	def gift_card_joins
		#	A study_subject has many gift cards so this may pose a problem
		"LEFT JOIN gift_cards ON gift_cards.study_subject_id = study_subjects.id" if( 
			search_gift_cards || %w( number issued_on ).include?(@order))
	end

	def q_conditions
		unless q.blank?
			c = []
			v = {}
			q.to_s.split(/\s+/).each_with_index do |t,i|
#				c.push("piis.first_name LIKE :t#{i}")
#				c.push("piis.last_name LIKE :t#{i}")
				c.push("first_name LIKE :t#{i}")
				c.push("last_name LIKE :t#{i}")
				c.push("identifiers.patid LIKE :t#{i}")
				c.push("identifiers.childid LIKE :t#{i}")
				c.push("gift_cards.number LIKE :t#{i}") if search_gift_cards
				v["t#{i}".to_sym] = "%#{t}%"
			end
			[ "( #{c.join(' OR ')} )", v ]
		end
	end

	def gift_card_conditions
		unless has_gift_card.nil?
			if has_gift_card
				["gift_cards.id IS NOT NULL"]
			else
				["gift_cards.id IS NULL"]
			end
		end
	end

	#	join order matters and this MUST come before
	#	those that join on home_outcomes!  Hmm?
	#	How?  Added a sort to joins and an "a_" to this
	def a_homex_outcome_joins
		"LEFT JOIN homex_outcomes ON homex_outcomes.study_subject_id " <<
			"= study_subjects.id" if( !sample_outcome.blank? ||
				!interview_outcome.blank? ||
				[ 'sample_outcome','sample_outcome_on','interview_outcome_on'].include?(@order) )
	end

	def sample_outcome_joins
		"LEFT JOIN sample_outcomes ON sample_outcomes.id = " <<
			"homex_outcomes.sample_outcome_id" unless
				sample_outcome.blank?
	end

	def sample_outcome_conditions
		unless sample_outcome.blank?
			if sample_outcome =~ /^Complete$/i
#				['sample_outcomes.code = :sample_outcome',{:sample_outcome => sample_outcome}]
				['sample_outcomes.code IS NOT NULL && sample_outcomes.code NOT IN ("Sent","Pending")']
			else
				["(sample_outcomes.code != 'Complete' " <<
						"OR sample_outcomes.code IS NULL)"]
			end
		end
	end

	def interview_outcome_joins
		"LEFT JOIN interview_outcomes ON interview_outcomes.id = " <<
			"homex_outcomes.interview_outcome_id" unless
				interview_outcome.blank?
	end

	def interview_outcome_conditions
		unless interview_outcome.blank?
			if interview_outcome =~ /^Complete$/i
				['interview_outcomes.code = :interview_outcome', {:interview_outcome => interview_outcome}]
			else
				["(interview_outcomes.code != 'Complete'" <<
					"OR interview_outcomes.code IS NULL)"]
			end
		end
	end

	def projects_joins
		unless projects.blank?
			s = ''
			projects.keys.each do |id|
				s << "JOIN enrollments proj_#{id} ON study_subjects.id "<<
						"= proj_#{id}.study_subject_id AND proj_#{id}.project_id = #{id} " 
			end
			s
		end
	end

	def projects_conditions
		unless projects.blank?
			conditions = []
			values = []
			projects.each do |id,attributes|
				attributes.each do |attr,val|
					val = [val].flatten
					if val.true_xor_false?
						new_condition = case attr.to_s.downcase
							when 'eligible'
								"proj_#{id}.is_eligible " <<
									((val.true?)?'= 1':'!= 1')
							when 'candidate'
								"proj_#{id}.is_candidate " <<
									((val.true?)?'= 1':'!= 1')
							when 'chosen'
								"proj_#{id}.is_chosen " <<
									((val.true?)?'= 1':'!= 1')
							when 'consented'
								"proj_#{id}.consented " <<
									((val.true?)?'= 1':'!= 1')
							when 'terminated'
								"proj_#{id}.terminated_participation " <<
									((val.true?)?'= 1':'!= 1')
							when 'closed'
								"proj_#{id}.is_closed " <<
									((val.true?)?'= 1':'!= 1')
							when 'completed'
								"proj_#{id}.completed_on IS " <<
									((val.true?)?'NOT NULL':'NULL')
						end	#	case attr.to_s.downcase
						conditions << new_condition unless new_condition.blank?
					end	#	if val.true_xor_false?
				end	#	attributes.each
			end #	projects.each
			[conditions.compact,values].flatten(1) unless conditions.empty?
		end #	unless projects.blank?
	end	#	def projects_conditions

	def abstracts_count_conditions
		unless @abstracts_count.blank?
			case @abstracts_count.to_s
				when '0' then ["abstracts_count <= 0"]
				when '1' then ["abstracts_count = 1"]
				when '2' then ["abstracts_count = 2"]
			end
		end
	end

end
