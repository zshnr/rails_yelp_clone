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

	it "should not see 'Add a restaurant' link" do
		visit('/')
		expect(page).not_to have_link('Add a restaurant')
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
end