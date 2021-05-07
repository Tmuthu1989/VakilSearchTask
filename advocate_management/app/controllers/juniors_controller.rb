class JuniorsController < ApplicationController
	before_action :set_junior, only: [:edit, :update, :destroy]
	before_action :check_user
	before_action :load_existing_juniors, only: [:new, :create]
	def index
		@juniors = current_user.juniors
	end

	def new
		@junior = User.new
		@existing_juniors = User.all_juniors.map{|jun| ["#{jun.name}(#{jun.advocate_number})", jun.id]}
	end

	def create
		@junior = current_user.juniors.new(junior_params)
		if @junior.save
			redirect_to juniors_path, notice: "Junior Advocate added successfully"
		else
			render :new
		end
	end

	def edit
		
	end

	def update
		if @junior.update(junior_params)
			redirect_to juniors_path, notice: "Junior Advocate updated successfully"
		else
			render :edit
		end
	end

	def destroy
		@junior.update(user_id: nil)
		redirect_to juniors_path, notice: "Junior Advocate removed successfully"

	end

	def add_juniors
		@juniors = User.where(id: params[:juniors]).update_all(user_id: current_user.id)
		redirect_to juniors_path, notice: "Junior Advocate added successfully"
	end

	private
		def set_junior
			@junior = User.find(params[:id])
		end

		def check_user
			redirect_to root_path, alert: "Unauthorized Access!" if current_user.junior_lawyer?
		end

		def junior_params
			params.require(:user).permit(:email, :user_id, :mobile_number, :first_name, :last_name, :phone_number, :date_of_birth, :role, :is_auto_pwd, :advocate_number, {state_ids: []})
		end

		def load_existing_juniors
			@existing_juniors = User.all_juniors.map{|jun| ["#{jun.name}(#{jun.advocate_number})", jun.id]}
		end
end
