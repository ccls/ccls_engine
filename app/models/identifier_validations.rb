#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module IdentifierValidations
#def self.included(base)
##	Must delay the calls to these ActiveRecord methods
##	or it will raise many "undefined method"s.
#base.class_eval do
#
#	validates_uniqueness_of :studyid, :allow_nil => true
#
#	validates_length_of :case_control_type, :is => 1, :allow_nil => true
#
##	TODO : add a validation for contents of orderno
##		won't have at creation
#
##	TODO I believe that subjectid is, or will be, a required field
##		it is auto-assigned so adding a validation that the user 
##		can't do anything about is a bad idea
##	validates_presence_of   :subjectid
##	validates_uniqueness_of :subjectid, :allow_nil => true
#
#	validates_length_of     :ssn, :maximum => 250, :allow_nil => true
#	validates_uniqueness_of :ssn, :allow_nil => true
#	validates_format_of     :ssn, :with => /\A\d{3}-\d{2}-\d{4}\z/,
#		:message => "should be formatted ###-##-####", :allow_nil => true
#
#	with_options :allow_nil => true do |n|
#		n.validates_uniqueness_of :icf_master_id
#		n.validates_uniqueness_of :state_id_no
#		n.validates_uniqueness_of :state_registrar_no
#		n.validates_uniqueness_of :local_registrar_no
#		n.validates_uniqueness_of	:gbid
#		n.validates_uniqueness_of	:lab_no_wiemels
#		n.validates_uniqueness_of	:accession_no
#		n.validates_uniqueness_of	:idno_wiemels
#	end
#
#	with_options :allow_blank => true do |blank|
#		blank.with_options :maximum => 250 do |o|
#			o.validates_length_of :state_id_no
#			o.validates_length_of :state_registrar_no
#			o.validates_length_of :local_registrar_no
#			o.validates_length_of :lab_no
#			o.validates_length_of :related_childid
#			o.validates_length_of :related_case_childid
#		end
#		blank.validates_length_of :childidwho, :maximum => 10
#		blank.validates_length_of :newid, :maximum => 6
#		blank.validates_length_of :gbid, :maximum => 26
#		blank.validates_length_of :lab_no_wiemels, :maximum => 25
#		blank.validates_length_of :idno_wiemels, :maximum => 10
#		blank.validates_length_of :accession_no, :maximum => 25
#		blank.validates_length_of :icf_master_id, :maximum => 9
#	end
#
#end	#	class_eval
#end	#	included
end	#	IdentifierValidations
