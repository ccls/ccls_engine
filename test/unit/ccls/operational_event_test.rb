require 'test_helper'

class Ccls::OperationalEventTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to(:enrollment)
	assert_should_initially_belong_to(:operational_event_type)

	assert_should_require_attributes( :enrollment_id )
	assert_should_not_require_attributes( :occurred_on, :description, :event_notes )

	assert_requires_complete_date(:occurred_on)
	assert_should_require_attribute_length( :description, :maximum => 250 )
	assert_should_require_attribute_length( :event_notes, :maximum => 65000 )

	test "explicit Factory operational_event test" do
		assert_difference('OperationalEventType.count',1) {
		assert_difference('OperationalEvent.count',1) {
			operational_event = Factory(:operational_event)
			assert_not_nil operational_event.operational_event_type
		} }
	end

	test "should require operational_event_type" do
		assert_difference( "OperationalEvent.count", 0 ) do
			operational_event = create_operational_event( :operational_event_type => nil)
			assert !operational_event.errors.on(:operational_event_type)
			assert  operational_event.errors.on_attr_and_type?(:operational_event_type_id,:blank)
		end
	end

	test "should require valid operational_event_type" do
		assert_difference( "OperationalEvent.count", 0 ) do
			operational_event = create_operational_event( :operational_event_type_id => 0)
			assert !operational_event.errors.on(:operational_event_type_id)
			assert  operational_event.errors.on_attr_and_type?(:operational_event_type,:blank)
		end
	end

	#	description is not required so ...
	test "should return description as to_s if not nil" do
		operational_event = create_operational_event(:description => 'testing')
		assert_equal operational_event.description, "#{operational_event}"
	end

#	test "should return NOT description as to_s if nil" do
#		operational_event = create_operational_event
#		assert_not_equal operational_event.description, "#{operational_event}"
#	end

	test "should order by type ASC" do
		oes = create_oet_operational_events
		events = OperationalEvent.search(:order => 'type',:dir => 'asc')
		assert_equal events, [oes[1],oes[0],oes[2]]
	end

	test "should order by type DESC" do
		oes = create_oet_operational_events
		events = OperationalEvent.search(:order => 'type',:dir => 'desc')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by type and DESC as default dir" do
		oes = create_oet_operational_events
		events = OperationalEvent.search(:order => 'type')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by description ASC" do
		oes = create_description_operational_events
		events = OperationalEvent.search(:order => 'description',:dir => 'asc')
		assert_equal events, [oes[1],oes[0],oes[2]]
	end

	test "should order by description DESC" do
		oes = create_description_operational_events
		events = OperationalEvent.search(:order => 'description',:dir => 'desc')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by description and DESC as default dir" do
		oes = create_description_operational_events
		events = OperationalEvent.search(:order => 'description')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by occurred_on ASC" do
		oes = create_occurred_on_operational_events
		events = OperationalEvent.search(:order => 'occurred_on',:dir => 'asc')
		assert_equal events, [oes[1],oes[0],oes[2]]
	end

	test "should order by occurred_on DESC" do
		oes = create_occurred_on_operational_events
		events = OperationalEvent.search(:order => 'occurred_on',:dir => 'desc')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by occurred_on and DESC as default dir" do
		oes = create_occurred_on_operational_events
		events = OperationalEvent.search(:order => 'occurred_on')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by occurred_on DESC as defaults" do
		oes = create_occurred_on_operational_events
		events = OperationalEvent.search()
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should ignore invalid order" do
		oes = create_occurred_on_operational_events
		events = OperationalEvent.search(:order => 'iambogus')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should ignore invalid dir" do
		oes = create_occurred_on_operational_events
		events = OperationalEvent.search(:order => 'occurred_on',
			:dir => 'iambogus')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should ignore valid dir without order" do
		oes = create_occurred_on_operational_events
		events = OperationalEvent.search(:dir => 'ASC')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should copy operational event type description on create" do
		operational_event = create_operational_event
		assert_equal operational_event.reload.description, 
			operational_event.operational_event_type.description
	end

	test "should only include operational events for study_subject" do
		enrollment = Factory(:enrollment)
		operational_event_1 = create_operational_event
		operational_event_2 = create_operational_event(
			:enrollment => enrollment )
		events = OperationalEvent.search(:study_subject_id => enrollment.study_subject.id)
		#	enrollment creates subject with auto-created ccls enrollment
		assert_equal 2, events.length
		assert events.include? operational_event_2
	end

protected

#	def create_operational_event(options={})
#		operational_event = Factory.build(:operational_event,options)
#		operational_event.save
#		operational_event
#	end

	def create_operational_events(*args)
		args.collect{|options| create_operational_event(options) }
	end

	def create_occurred_on_operational_events
		today = Date.today
		create_operational_events(
			{ :occurred_on => ( today - 1.month ) },
			{ :occurred_on => ( today - 1.year ) },
			{ :occurred_on => ( today - 1.week ) }
		)
	end

	def create_description_operational_events
		create_operational_events(
			{ :description => 'M' },
			{ :description => 'A' },
			{ :description => 'Z' }
		)
	end

	def create_oet_operational_events
		create_operational_events(
			{ :operational_event_type => Factory(
				:operational_event_type,:description => 'MMMM') },
			{ :operational_event_type => Factory(
				:operational_event_type,:description => 'AAAA') },
			{ :operational_event_type => Factory(
				:operational_event_type,:description => 'ZZZZ') }
		)
	end

end
