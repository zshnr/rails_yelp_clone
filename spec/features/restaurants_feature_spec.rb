require 'rails_helper'

describe 'restaurants' do

	context 'no restaurants have been added' do
		before do
			@test = User.create(email: "test@test.com", password: "test1234", password_confirmation: "test1234")
			login_as @test
		end
		it 'should display a prompt to add a restaurant' do
			visit '/restaurants'
			expect(page).to have_content 'No restaurants'
			expect(page).to have_link 'Add a restaurant'
		end

		context 'creating restaurants' do

			it 'prompts user to fill out a form, then displays the new restaurant' do
				visit '/restaurants'
				click_link 'Add a restaurant'
				fill_in 'Name', with: 'KFC'
				click_button 'Create Restaurant'
				expect(page).to have_content 'KFC'
				expect(current_path).to eq '/restaurants'
			end
		end
	end

	context 'restaurants have been added' do
		before do
			@test = User.create(email: "test@test.com", password: "test1234", password_confirmation: "test1234")
			login_as @test
			@kfc = @test.restaurants.create(name:'KFC')
		end
		
		it 'should display restaurants' do
			visit '/restaurants'
			expect(page).to have_content('KFC')
			expect(page).not_to have_content('No restaurants yet')
		end

		context 'viewing restaurants' do

			it 'lets a user view a restaurant' do
				visit '/restaurants'
				click_link 'KFC'
				expect(page).to have_content 'KFC'
				expect(current_path).to eq "/restaurants/#{@kfc.id}"
			end
		end

		context 'editing restaurants' do

			it 'lets a user edit a restaurant' do
				visit '/restaurants'
				click_link 'Edit KFC'
				fill_in 'Name', with: 'Kentucky Fried Chicken'
				click_button 'Update Restaurant'
				expect(page).to have_content 'Kentucky Fried Chicken'
				expect(current_path).to eq '/restaurants'
			end
		end

		context 'an invalid restaurant' do
			it 'does not let you submit a name that is too short' do
				visit '/restaurants'
				click_link 'Add a restaurant'
				fill_in 'Name', with: 'kf'
				click_button 'Create Restaurant'
				expect(page).not_to have_css 'h2', text: 'kf'
				expect(page).to have_content 'error'		
			end
		end

		context 'deleting restaurants' do

			it 'removes a restaurant when a user clicks a delete link' do
				visit '/restaurants'
				click_link 'Delete KFC'
				expect(page).not_to have_content 'KFC'
				expect(page).to have_content 'Restaurant deleted successfully'
			end
		end
	end
end