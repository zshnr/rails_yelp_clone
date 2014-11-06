class ReviewsController < ApplicationController

	before_action :authenticate_user!

	def new
		@restaurant = Restaurant.find(params[:restaurant_id])
		@review = Review.new
		@hasReview = @restaurant.reviews.where(:user_id == current_user.id)
		if @hasReview.count > 0
			flash[:notice] = 'You have already reviewed this restaurant'
			redirect_to root_path
		end
	end

	def create
		@restaurant = Restaurant.find(params[:restaurant_id])
		@restaurant.reviews.create(review_params)
		redirect_to restaurants_path
	end

	def review_params
		params.require(:review).permit(:thoughts, :rating)
	end
end
