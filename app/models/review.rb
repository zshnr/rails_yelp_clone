class Review < ActiveRecord::Base
	belongs_to :restaurants
	belongs_to :users
	validates :rating, inclusion: (1..5)
	validates_uniqueness_of :user_id, :scope => :restaurant_id
end
