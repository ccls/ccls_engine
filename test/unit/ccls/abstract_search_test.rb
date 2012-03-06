require 'test_helper'

class Ccls::AbstractSearchTest < ActiveSupport::TestCase

#	test "should return AbstractSearch" do
#		assert AbstractSearch().is_a?(AbstractSearch)
#	end 

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

	test "should include abstract by q first_name" do
		a1,a2 = create_abstracts_with_first_names('Michael','Bob')
		assert_equal 'Michael', a1.study_subject.first_name
		abstracts = Abstract.search(:q => 'mi ch ha')
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

	test "should include abstract by q last_name" do
		a1,a2 = create_abstracts_with_last_names('Michael','Bob')
		assert_equal 'Michael', a1.study_subject.last_name
		abstracts = Abstract.search(:q => 'cha ael')
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

	test "should include abstract by q childid" do
		a1,a2 = create_abstracts_with_childids(999999,'1')
		assert_equal 999999, a1.study_subject.childid
		abstracts = Abstract.search(:q => a1.study_subject.childid)
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

	test "should include abstract by q patid" do
		a1,a2 = create_abstracts_with_patids(9999,'1')
		assert_equal '9999', a1.study_subject.patid
		abstracts = Abstract.search(:q => a1.study_subject.patid)
		assert  abstracts.include?(a1)
		assert !abstracts.include?(a2)
	end

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

protected 

	def create_abstracts(count=0,options={})
		abstracts = []
		count.times{ abstracts.push(create_abstract(options)) }
		return abstracts
	end

	def create_abstract_with_first_name(first_name)
		study_subject  = create_study_subject_with_first_name(first_name)
		abstract = create_abstract
		study_subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_last_name(last_name)
		study_subject  = create_study_subject_with_last_name(last_name)
		abstract = create_abstract
		study_subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_childid(childid)
		study_subject  = create_study_subject_with_childid(childid)
		abstract = create_abstract
		study_subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_patid(patid)
		study_subject  = create_study_subject_with_patid(patid)
		abstract = create_abstract
		study_subject.abstracts << abstract
		abstract
	end

end
