class HttpService
	
	def HttpService.make_request(url, pay_load={}, headers={}, req_method="get")
		response = RestClient::Request.execute(method: req_method, payload: pay_load.to_json, url: url, headers: headers)
		JSON.parse(response.body, object_class: OpenStruct)
	end
	
end