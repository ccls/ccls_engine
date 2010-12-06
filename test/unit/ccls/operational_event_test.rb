require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:enrollment)
	assert_should_initially_belong_to(:operational_event_type)
	assert_should_not_require_attributes( :occurred_on )
	assert_should_not_require_attributes( :enrollment_id )
	assert_should_not_require_attributes( :description )

	assert_requires_complete_date(:occurred_on)

	assert_should_require_attribute_length( :description, :maximum => 250 )

	#	description is not required so ...
	test "should return description as to_s if not nil" do
		object = create_object(:description => 'testing')
		assert_equal object.description, "#{object}"
	end

	test "should return NOT description as to_s if nil" do
		object = create_object
		assert_not_equal object.description, "#{object}"
	end

	test "should order by type ASC" do
		oes = create_oet_objects
		events = OperationalEvent.search(:order => 'type',:dir => 'asc')
		assert_equal events, [oes[1],oes[0],oes[2]]
	end

	test "should order by type DESC" do
		oes = create_oet_objects
		events = OperationalEvent.search(:order => 'type',:dir => 'desc')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by type and DESC as default dir" do
		oes = create_oet_objects
		events = OperationalEvent.search(:order => 'type')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by description ASC" do
		oes = create_description_objects
		events = OperationalEvent.search(:order => 'description',:dir => 'asc')
		assert_equal events, [oes[1],oes[0],oes[2]]
	end

	test "should order by description DESC" do
		oes = create_description_objects
		events = OperationalEvent.search(:order => 'description',:dir => 'desc')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by description and DESC as default dir" do
		oes = create_description_objects
		events = OperationalEvent.search(:order => 'description')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by occurred_on ASC" do
		oes = create_occurred_on_objects
		events = OperationalEvent.search(:order => 'occurred_on',:dir => 'asc')
		assert_equal events, [oes[1],oes[0],oes[2]]
	end

	test "should order by occurred_on DESC" do
		oes = create_occurred_on_objects
		events = OperationalEvent.search(:order => 'occurred_on',:dir => 'desc')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by occurred_on and DESC as default dir" do
		oes = create_occurred_on_objects
		events = OperationalEvent.search(:order => 'occurred_on')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should order by occurred_on DESC as defaults" do
		oes = create_occurred_on_objects
		events = OperationalEvent.search()
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should ignore invalid order" do
		oes = create_occurred_on_objects
		events = OperationalEvent.search(:order => 'iambogus')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should ignore invalid dir" do
		oes = create_occurred_on_objects
		events = OperationalEvent.search(:order => 'occurred_on',
			:dir => 'iambogus')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

	test "should ignore valid dir without order" do
		oes = create_occurred_on_objects
		events = OperationalEvent.search(:dir => 'ASC')
		assert_equal events, [oes[2],oes[0],oes[1]]
	end

protected

	def create_objects(*args)
		args.collect{|options| create_object(options) }
	end

	def create_occurred_on_objects
		create_objects(
			{ :occurred_on => Chronic.parse('last month') },
			{ :occurred_on => Chronic.parse('last year') },
			{ :occurred_on => Chronic.parse('last week') }
		)
	end

	def create_description_objects
		create_objects(
			{ :description => 'M' },
			{ :description => 'A' },
			{ :description => 'Z' }
		)
	end

	def create_oet_objects
		create_objects(
			{ :operational_event_type => Factory(
				:operational_event_type,:description => 'MMMM') },
			{ :operational_event_type => Factory(
				:operational_event_type,:description => 'AAAA') },
			{ :operational_event_type => Factory(
				:operational_event_type,:description => 'ZZZZ') }
		)
	end

end
