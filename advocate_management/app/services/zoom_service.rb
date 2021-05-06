class ZoomService
	BASE_URL = "https://api.zoom.us/v2"
		
	def get_auth_token
		api_key = "kbCPgXasRvq-on_Vsr4vHg" #Rails.application.credentials[:zoom_us][:key]
		api_secret = "IcrcW0YIjNXKjrZUTo7ZpkvKcD3RhjXYioUf" #Rails.application.credentials[:zoom_us][:secret]
		pay_load = {
			iss: api_key,
			exp: 5.minutes.from_now.to_i
		}
		JWT.encode(pay_load, api_secret, "HS256", {typ: "JWT"})
	end

	def users
		HttpService.make_request("#{BASE_URL}/users", {}, headers)
	end

	def create_user(pay_load)
		HttpService.make_request("#{BASE_URL}/users", pay_load, headers, "post")
	end

	def user_detail(user_id)
		HttpService.make_request("#{BASE_URL}/users/#{user_id}", {}, headers)
	end

	def meetings(user_id)
		HttpService.make_request("#{BASE_URL}/users/#{user_id}/meetings", {}, headers)
	end

	def create_meeting(user_id, pay_load)
		HttpService.make_request("#{BASE_URL}/users/#{user_id}/meetings", pay_load, headers, "post")
	end

	def update_meeting(meeting_id, pay_load)
		HttpService.make_request("#{BASE_URL}/meetings/#{meeting_id}", pay_load, headers, "patch")
	end

	def delete_meeting(meeting_id, pay_load)
		HttpService.make_request("#{BASE_URL}/meetings/#{meeting_id}", pay_load, headers, "delete")
	end

	def update_meeting_status(meeting_id, pay_load)
		HttpService.make_request("#{BASE_URL}/meetings/#{meeting_id}", pay_load, headers, "put")
	end

	private
		def headers
			{"Authorization" => "Bearer #{get_auth_token}", "content-type" => "application/json"}
		end
end