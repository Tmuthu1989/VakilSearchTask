User.find_or_create_by(email: "admin@advocate.com") do |t|
	t.first_name = "Advocate Management"
	t.last_name = "Admin"
	t.user_type = AppConstants::USER_TYPE_ADMIN
	t.password = "admin@123"
	t.password_confirmation = "admin@123"
	t.role = AppConstants::ROLE_ADMIN
end
State.load_states