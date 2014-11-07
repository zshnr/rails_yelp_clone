require 'rails_helper'

describe 'before reviewing' do
	before do
		@test = User.create(email: "test@test.com", password: "test1234", password_confirmation: "test1234")
		login_as @test
		@test.restaurants.create(name: "KFC")
		logout
	end

	it "user must be logged in to leave a review" do
		visit('/restaurants')
		click_link('Review KFC')
		expect(current_path).to eq("/users/sign_in")
	end
end

describe 'reviewing' do
	before do
		@test = User.create(email: "test@test.com", password: "test1234", password_confirmation: "test1234")
		login_as @test
		@kfc = @test.restaurants.create(name: "KFC")
	end

	it 'allows users to leave a review using a form' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		expect(current_path).to eq '/restaurants'
		expect(page).to have_content('so so')
	end

	it "allows users to only leave one review per restaurant" do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		click_link 'Review KFC'
		expect(page).to have_content('You have already reviewed this restaurant')
	end

	it "allows reviews to be deleted" do
		@kfc.reviews.create(thoughts: "so so", rating: 3, user_id: @test.id)
		visit('/')
		click_link 'Delete Review'
		expect(page).not_to have_content "so so"
		expect(page).to have_content "Review deleted successfully"
	end
end