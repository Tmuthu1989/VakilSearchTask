class TestingTask
	def join_string(input_arr)
		matched_chars = []
		result = ""
		prev_matched_str = ""
		input_arr.each_with_index do |str, ind|
			next_str = input_arr[ind+1]
			str = str[prev_matched_str.length..-1]
			result += str
			while str.to_s != ""
				if next_str.to_s != ""
					if next_str.start_with?(str)
						prev_matched_str = str
						matched_chars << str.length
						str = ""
					else
						str = str[1..-1]
					end
				else
					str = ""
				end
			end
		end
		[result, matched_chars.min]
	end
end
obj = TestingTask.new
puts obj.join_string(["oven", "envier", "erase", "serious"]).inspect
puts obj.join_string(["move", "over", "very"]).inspect
puts obj.join_string(["to", "ops", "psy", "syllable"]).inspect