require 'rails_helper'

context 'user not signed in and on the homepage' do
	it "should see a 'sign in' link and a 'sign up' link" do
		visit('/')
		expect(page).to have_link('Sign in')
		expect(page).to have_link('Sign up')
	end

	it "should not see 'sign out' link" do
		visit('/')
		expect(page).not_to have_link('Sign out')
	end

	it "should see login in page when clicks 'Add a restaurant' link" do
		visit('/')
		click_link('Add a restaurant')
		expect(current_path).to eq('/users/sign_in')
	end
end

context 'user signed in' do
	before do
		@test = User.create(email: "test@test.com", password: "test1234", password_confirmation: "test1234")
		login_as @test
	end

	it "on the homepage should see 'sign out' link" do
		visit('/')
		expect(page).to have_link('Sign out')
	end

	it "on the homepage should not see a 'sign in' link and a 'sign up' link" do
		visit('/')
		expect(page).not_to have_link('Sign in')
		expect(page).not_to have_link('Sign up')
	end

	it "can only edit a restaurant that they've created" do
		@test.restaurants.create(name: "KFC")
		visit('/')
		expect(page).to have_link('Edit KFC')
	end

	it "cannot edit a restaurant they've not created" do
		@anotheruser = User.create(email: "au@au.com", password: "test1234", password_confirmation: "test1234")
		@anotheruser.restaurants.create(name: "Naughty Noodles")
		visit('/')
		expect(page).not_to have_link('Edit Naughty Noodles')
	end

	it "can only delete a restaurant that they have created" do
		@test.restaurants.create(name: "KFC")
		visit('/')
		expect(page).to have_link('Delete KFC')
	end

	it "cannot delete a restaurant that they have not created" do
		@anotheruser = User.create(email: "au@au.com", password: 'test1234', password_confirmation: "test1234")
		@anotheruser.restaurants.create(name: "Naughty Noodles")
		visit('/')
		expect(page).not_to have_link('Delete Naughty Noodles')
	end
end