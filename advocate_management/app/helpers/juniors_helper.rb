module JuniorsHelper

	def form_url
		@junior.new_record? ? juniors_path : junior_path(@junior)
	end
end
