class CasesController < ApplicationController
	before_action :set_case, except: [:index, :new, :create]

	def index
		@cases = Case.all_cases(current_user).group_by(&:state_id)
		@states = State.all.map { |e| [e.id, "#{e.name}(#{e.code})"] }.to_h
	end

	def new
		@case = Case.new
	end

	def create
		@case = current_user.cases.new(cases_params)
		if @case.save
			redirect_to cases_path, notice: "Case added successfully"
		else
			render :new
		end
	end

	def update
		if @case.update(cases_params)
			redirect_to cases_path, notice: "Case updated successfully"
		else
			render :edit
		end
	end

	def reject
		@case.update(is_blocked: true)
			redirect_to cases_path, notice: "Case rejected successfully"

	end

	def destroy
		@case.destroy
		redirect_to cases_path, notice: "Case deleted successfully"
	end

	private
		def set_case
			@case = Case.find(params[:id] || params[:case_id])
		end

		def cases_params
			params.require(:case).permit(:number, :client_name, :state_id)
		end
end
