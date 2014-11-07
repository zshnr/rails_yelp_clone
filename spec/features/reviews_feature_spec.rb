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
		leave_review('so so', "3")
		expect(current_path).to eq '/restaurants'
		expect(page).to have_content('so so')
	end

	it "allows users to only leave one review per restaurant" do
		leave_review('so so', "3")
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

	it "allows users to only delete reviews that they have created" do
		@kfc.reviews.create(thoughts: "so so", rating: 3, user_id: @test.id)
		logout
		@anotheruser = User.create(email: "au@au.com", password: "test1234", password_confirmation: "test1234")
		login_as @anotheruser
		visit('/')
		expect(page).not_to have_link "Delete Review"
	end

	it "displays an average rating for all reviews" do
		leave_review('so so', "3")
		@anotheruser = User.create(email: "au@au.com", password: "test1234", password_confirmation: "test1234")
		login_as @anotheruser
		leave_review('Finger licking good', "5")
		expect(page).to have_content("Average rating: ★★★★☆")
	end
end

def leave_review(thoughts, rating)
	visit'/restaurants'
	click_link 'Review KFC'
	fill_in "Thoughts", with: thoughts
	select rating, from: 'Rating'
	click_button 'Leave Review'
end