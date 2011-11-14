class AddNewConsentFieldsToEnrollments < SharedMigration
	def self.up
		add_column :enrollments, :use_smp_future_rsrch, :integer
		add_column :enrollments, :use_smp_future_cancer_rsrch, :integer
		add_column :enrollments, :use_smp_future_other_rsrch, :integer
		add_column :enrollments, :share_smp_with_others, :integer
		add_column :enrollments, :contact_for_related_study, :integer
		add_column :enrollments, :provide_saliva_smp, :integer
		add_column :enrollments, :receive_study_findings, :integer
	end

	def self.down
		remove_column :enrollments, :receive_study_findings
		remove_column :enrollments, :provide_saliva_smp
		remove_column :enrollments, :contact_for_related_study
		remove_column :enrollments, :share_smp_with_others
		remove_column :enrollments, :use_smp_future_other_rsrch
		remove_column :enrollments, :use_smp_future_cancer_rsrch
		remove_column :enrollments, :use_smp_future_rsrch
	end
end
