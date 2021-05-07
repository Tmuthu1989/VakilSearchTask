class Case < ApplicationRecord
	belongs_to :advocate, class_name: "User"
	belongs_to :state
	validates :client_name, :number, presence: true
	validate :uniq_case
	def Case.all_cases(user)
		cases = user.senior_lawyer? ? Case.where("advocate_id in (?)", [user.id]+user.juniors.pluck(:id)) : user.cases
		cases.where(is_blocked: [nil, false])
	end

	def uniq_case
		id_cond = new_record? ? {} : "id != #{self.id}"
		case_obj = Case.where(id_cond).where(number: self.number).first
		if case_obj.present?
			errors[:case_number] << (case_obj.is_blocked ? "has been rejected. You cannot add same case again!" : "has been already exist")
		end
	end
end
