class EndorsementsController < ApplicationController

	def index
		@review = Review.find(params[:review_id])
	    @review.endorsements.create
	    respond_to do |format|
		    format.html {redirect_to restaurants_path}
		    format.json {render :json => {new_endorsement_count: @review.endorsements.count} }
  		end
	end
	# def create
	# 	@review = Review.find(params[:review_id])
	# 	@review.endorsements.create
	# 	render json: {new_endorsement_count: @review.endorsements.count}
	# end
end
