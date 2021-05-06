class JuniorsController < ApplicationController
	def index
		@juniors = current_user.juniors
	end

	def new
		@junior = User.new
	end

	def create
		@junior = current_user.juniors.build(junior_params)
		if @junior.save
		else
		end
	end
end
