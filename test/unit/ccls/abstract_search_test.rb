require 'test_helper'

class AbstractSearchTest < ActiveSupport::TestCase

	test "should return AbstractSearch" do
		assert AbstractSearch().is_a?(AbstractSearch)
	end 

	test "should respond to search" do
		assert Abstract.respond_to?(:search)
	end

	test "should return Array" do
		abstracts = Abstract.search()
		assert abstracts.is_a?(Array)
	end

	test "should include abstract" do
		abstract = create_abstract
		#	there are already about 40 in the fixtures
		#	so we need to get more than that to include the last one.
		abstracts = Abstract.search(:per_page => 50)
		assert abstracts.include?(abstract)
	end

	test "should include abstract without pagination" do
		abstract = create_abstract
		abstracts = Abstract.search(:paginate => false)
		assert abstracts.include?(abstract)
	end

	test "should NOT order by bogus column with dir" do
		Abstract.destroy_all
		a1,a2,a3 = create_abstracts(3)
		abstracts = Abstract.search(
			:order => 'whatever', :dir => 'asc')
		assert_equal [a1,a2,a3], abstracts
	end

	test "should NOT order by bogus column" do
		Abstract.destroy_all
		a1,a2,a3 = create_abstracts(3)
		abstracts = Abstract.search(:order => 'whatever')
		assert_equal [a1,a2,a3], abstracts
	end

	test "should order by id asc by default" do
		Abstract.destroy_all
		a1,a2,a3 = create_abstracts(3)
		abstracts = Abstract.search(
			:order => 'id')
		assert_equal [a1,a2,a3], abstracts
	end

	test "should order by id asc" do
		Abstract.destroy_all
		a1,a2,a3 = create_abstracts(3)
		abstracts = Abstract.search(
			:order => 'id', :dir => 'asc')
		assert_equal [a1,a2,a3], abstracts
	end

	test "should order by id desc" do
		Abstract.destroy_all
		a1,a2,a3 = create_abstracts(3)
		abstracts = Abstract.search(
			:order => 'id', :dir => 'desc')
		assert_equal [a3,a2,a1], abstracts
	end

#	Can't search across multiple databases.
#	So doing a double search.

	test "should include abstract by q first_name" do
		a1,a2 = create_abstracts_with_first_names('Michael','Bob')
		assert_equal 'Michael', a1.subject.first_name
		abstracts = Abstract.search(:q => 'mi ch ha')
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

	test "should include abstract by q last_name" do
		a1,a2 = create_abstracts_with_last_names('Michael','Bob')
		assert_equal 'Michael', a1.subject.last_name
		abstracts = Abstract.search(:q => 'cha ael')
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

	test "should include abstract by q childid" do
		a1,a2 = create_abstracts_with_childids(999999,'1')
		assert_equal 999999, a1.subject.childid
		abstracts = Abstract.search(:q => a1.subject.identifier.childid)
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

	test "should include abstract by q patid" do
		a1,a2 = create_abstracts_with_patids(999999,'1')
		assert_equal 999999, a1.subject.patid
		abstracts = Abstract.search(:q => a1.subject.identifier.patid)
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

#	test "should include abstract by q number" do
#		a1,a2 = create_abstracts_with_numbers('9999','1111')
#		abstracts = Abstract.search(:q => a1.number)
#		assert  abstracts.include?(a1)
#		assert !abstracts.include?(a2)
#	end

	test "should find abstracts that are merged" do
		a1,a2 = create_abstracts(2)
		a1.merged_by = Factory(:user)
		a1.save
		assert  a1.merged?
		assert !a2.merged?
		abstracts = Abstract.search(:merged => true)
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

end
