class CreateHomeExposureResponses < SharedMigration
	def self.up
		create_table :home_exposure_responses do |t|
#			t.integer :childid
			t.integer :subject_id
#	If it is an HER, then it is complete
#	Only the response sets may be incomplete.
#			t.boolean :is_complete
			t.integer :vacuum_has_disposable_bag
			t.integer :how_often_vacuumed_12mos
			t.integer :shoes_usually_off_inside_12mos
			t.integer :someone_ate_meat_12mos
			t.integer :freq_pan_fried_meat_12mos
			t.integer :freq_deep_fried_meat_12mos
			t.integer :freq_oven_fried_meat_12mos
			t.integer :freq_grilled_meat_outside_12mos
			t.integer :freq_other_high_temp_cooking_12mos
			t.string :other_type_high_temp_cooking
			t.integer :doneness_of_meat_exterior_12mos
			t.integer :job_is_plane_mechanic_12mos
			t.integer :job_is_artist_12mos
			t.integer :job_is_janitor_12mos
			t.integer :job_is_construction_12mos
			t.integer :job_is_dentist_12mos
			t.integer :job_is_electrician_12mos
			t.integer :job_is_engineer_12mos
			t.integer :job_is_farmer_12mos
			t.integer :job_is_gardener_12mos
			t.integer :job_is_lab_worker_12mos
			t.integer :job_is_manufacturer_12mos
			t.integer :job_auto_mechanic_12mos
			t.integer :job_is_patient_care_12mos
			t.integer :job_is_agr_packer_12mos
			t.integer :job_is_painter_12mos
			t.integer :job_is_pesticides_12mos
			t.integer :job_is_photographer_12mos
			t.integer :job_is_teacher_12mos
			t.integer :job_is_welder_12mos
			t.integer :used_flea_control_12mos
			t.integer :freq_used_flea_control_12mos
			t.integer :used_ant_control_12mos
			t.integer :freq_ant_control_12mos
			t.integer :used_bee_control_12mos
			t.integer :freq_bee_control_12mos
			t.integer :used_indoor_plant_prod_12mos
			t.integer :freq_indoor_plant_product_12mos
			t.integer :used_other_indoor_product_12mos
			t.integer :freq_other_indoor_product_12mos
			t.integer :used_indoor_foggers
			t.integer :freq_indoor_foggers_12mos
			t.integer :used_pro_pest_inside_12mos
			t.integer :freq_pro_pest_inside_12mos
			t.integer :used_pro_pest_outside_12mos
			t.integer :freq_used_pro_pest_outside_12mos
			t.integer :used_pro_lawn_service_12mos
			t.integer :freq_pro_lawn_service_12mos
			t.integer :used_lawn_products_12mos
			t.integer :freq_lawn_products_12mos
			t.integer :used_slug_control_12mos
			t.integer :freq_slug_control_12mos
			t.integer :used_rat_control_12mos
			t.integer :freq_rat_control_12mos
			t.integer :used_mothballs_12mos
			t.integer :cmty_sprayed_gypsy_moths_12mos
			t.integer :cmty_sprayed_medflies_12mos
			t.integer :cmty_sprayed_mosquitoes_12mos
			t.integer :cmty_sprayed_sharpshooters_12mos
			t.integer :cmty_sprayed_apple_moths_12mos
			t.integer :cmty_sprayed_other_pest_12mos
			t.string :other_pest_community_sprayed
			t.integer :type_of_residence
			t.string :other_type_of_residence
			t.integer :number_of_floors_in_residence
			t.integer :number_of_stories_in_building
			t.integer :year_home_built
			t.integer :home_square_footage
			t.integer :number_of_rooms_in_home
			t.integer :home_constructed_of
			t.string :other_home_material
			t.integer :home_has_attached_garage
			t.integer :vehicle_in_garage_1mo
			t.integer :freq_in_out_garage_1mo
			t.integer :home_has_electric_cooling
			t.integer :freq_windows_open_cold_mos_12mos
			t.integer :freq_windows_open_warm_mos_12mos
			t.integer :used_electric_heat_12mos
			t.integer :used_kerosene_heat_12mos
			t.integer :used_radiator_12mos
			t.integer :used_gas_heat_12mos
			t.integer :used_wood_burning_stove_12mos
			t.integer :freq_used_wood_stove_12mos
			t.integer :used_wood_fireplace_12mos
			t.integer :freq_used_wood_fireplace_12mos
			t.integer :used_fireplace_insert_12mos
			t.integer :used_gas_stove_12mos
			t.integer :used_gas_dryer_12mos
			t.integer :used_gas_water_heater_12mos
			t.integer :used_other_gas_appliance_12mos
			t.string :type_of_other_gas_appliance
			t.integer :painted_inside_home
			t.integer :carpeted_in_home
			t.integer :refloored_in_home
			t.integer :weather_proofed_home
			t.integer :replaced_home_windows
			t.integer :roof_work_on_home
			t.integer :construction_in_home
			t.integer :other_home_remodelling
			t.string :type_other_home_remodelling
			t.integer :regularly_smoked_indoors
			t.integer :regularly_smoked_indoors_12mos
			t.integer :regularly_smoked_outdoors
			t.integer :regularly_smoked_outdoors_12mos
			t.integer :used_smokeless_tobacco_12mos
			t.integer :qty_of_upholstered_furniture
			t.integer :qty_bought_after_2006
			t.integer :furniture_has_exposed_foam
			t.integer :home_has_carpets
			t.integer :percent_home_with_carpet
			t.integer :home_has_televisions
			t.integer :number_of_televisions_in_home
			t.integer :avg_number_hours_tvs_used
			t.integer :home_has_computers
			t.integer :number_of_computers_in_home
			t.integer :avg_number_hours_computers_used
			t.text :additional_comments

			t.integer :vacuum_bag_last_changed
			t.integer :vacuum_used_outside_home

			t.timestamps
		end
		add_index :home_exposure_responses, :subject_id, :unique => true
	end

	def self.down
		drop_table :home_exposure_responses
	end
end
