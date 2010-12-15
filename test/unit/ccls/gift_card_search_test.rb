require 'test_helper'

class Ccls::GiftCardSearchTest < ActiveSupport::TestCase

	test "should return GiftCardSearch" do
		assert GiftCardSearch().is_a?(GiftCardSearch)
	end 

	test "should respond to search" do
		assert GiftCard.respond_to?(:search)
	end

	test "should return Array" do
		gift_cards = GiftCard.search()
		assert gift_cards.is_a?(Array)
	end

	test "should include gift_card" do
		gift_card = create_gift_card
		#	there are already about 40 in the fixtures
		#	so we need to get more than that to include the last one.
		gift_cards = GiftCard.search(:per_page => 50)
		assert gift_cards.include?(gift_card)
	end

	test "should include gift_card without pagination" do
		gift_card = create_gift_card
		gift_cards = GiftCard.search(:paginate => false)
		assert gift_cards.include?(gift_card)
	end

	test "should NOT order by bogus column with dir" do
		GiftCard.destroy_all
		g1,g2,g3 = create_gift_cards(3)
		gift_cards = GiftCard.search(
			:order => 'whatever', :dir => 'asc')
		assert_equal [g1,g2,g3], gift_cards
	end

	test "should NOT order by bogus column" do
		GiftCard.destroy_all
		g1,g2,g3 = create_gift_cards(3)
		gift_cards = GiftCard.search(:order => 'whatever')
		assert_equal [g1,g2,g3], gift_cards
	end

	test "should order by id asc by default" do
		GiftCard.destroy_all
		g1,g2,g3 = create_gift_cards_with_childids(9,3,6)
		gift_cards = GiftCard.search(
			:order => 'id')
		assert_equal [g1,g2,g3], gift_cards
	end

	test "should order by id asc" do
		GiftCard.destroy_all
		g1,g2,g3 = create_gift_cards_with_childids(9,3,6)
		gift_cards = GiftCard.search(
			:order => 'id', :dir => 'asc')
		assert_equal [g1,g2,g3], gift_cards
	end

	test "should order by id desc" do
		GiftCard.destroy_all
		g1,g2,g3 = create_gift_cards_with_childids(9,3,6)
		gift_cards = GiftCard.search(
			:order => 'id', :dir => 'desc')
		assert_equal [g3,g2,g1], gift_cards
	end

	test "should include gift_card by q first_name" do
		g1,g2 = create_gift_cards_with_first_names('Michael','Bob')
		gift_cards = GiftCard.search(:q => 'mi ch ha')
		assert  gift_cards.include?(g1)
		assert !gift_cards.include?(g2)
	end

	test "should include gift_card by q last_name" do
		g1,g2 = create_gift_cards_with_last_names('Michael','Bob')
		gift_cards = GiftCard.search(:q => 'cha ael')
		assert  gift_cards.include?(g1)
		assert !gift_cards.include?(g2)
	end

	test "should include gift_card by q childid" do
		g1,g2 = create_gift_cards_with_childids(999999,'1')
		gift_cards = GiftCard.search(:q => g1.subject.identifier.childid)
		assert  gift_cards.include?(g1)
		assert !gift_cards.include?(g2)
	end

	test "should include gift_card by q patid" do
		g1,g2 = create_gift_cards_with_patids(999999,'1')
		gift_cards = GiftCard.search(:q => g1.subject.identifier.patid)
		assert  gift_cards.include?(g1)
		assert !gift_cards.include?(g2)
	end

	test "should include gift_card by q number" do
		g1,g2 = create_gift_cards_with_numbers('9999','1111')
		gift_cards = GiftCard.search(:q => g1.number)
		assert  gift_cards.include?(g1)
		assert !gift_cards.include?(g2)
	end


end
