class TestingTask
	def join_string(input_arr)
		puts "Input: #{input_arr}"
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
						break
					end
					str = str[1..-1]
					next
				end
				break
			end
		end
		puts "Output: \"#{result}\", Min Chars Matched: #{matched_chars.min}\n"
		puts "-------------------------\n\n"
		[result, matched_chars.min]
	end

	def sudoku_validator(input_arr)
		rows_arr = input_arr
		cols_arr = [] 
		three_x_three_arr = [] 
		# we can use rows_arr.transpose to reverse cols to rows instead of this logic
		# Logic Start here to reverse cols to rows
		puts "Input Sudoku Array:"
		rows_arr.each{|elem|
			puts "#{elem}"
			elem.each_with_index { |row_elem, ind|
				cols_arr[ind] ||= []
				cols_arr[ind] << row_elem
			}
		}
		# Logic Ends Here
		# To Get 3X3 Array - Start
		i = 0
		input_arr.each_with_index do |row_elem, ind|
			j = 0
			i = ind == 0 ? i : i+3 if ind %3 == 0
			3.times do |n|
				three_x_three_arr[i+n] ||= []
				three_x_three_arr[i+n] += row_elem[j...j+=3]
			end
		end
		#end of 3X3 Array
		result = check_valid(rows_arr) && check_valid(cols_arr) && check_valid(three_x_three_arr) ? "Valid Sudoku" : "Invalid Sudoku"	
		puts "\nOutput: #{result}"
		puts "------------------------------------\n\n"
		result
	end

	def count_boomerang(input_arr)
		puts "Input: #{input_arr}\n\n"
		count = 0
		boomerangs = []
		input_arr.each_with_index do |elem, ind|
			next if ind == 0
			prev_elem, next_elem = input_arr[ind-1], input_arr[ind+1]
			if prev_elem == next_elem && (elem < prev_elem || elem > prev_elem)
				count += 1
				boomerangs << [prev_elem, elem, next_elem]
			end
		end
		puts "Output:"
		puts "No. of Boomerangs: #{count}, Boomerang: #{boomerangs}\n\n-----------------------"
		[boomerangs, count]
	end

	private

		def check_valid(input_arr)
			is_valid = true
			input_arr.each do |elem|
				if elem.uniq.length != elem.length
					is_valid = false
					break
				end
			end
			is_valid
		end
end
obj = TestingTask.new
puts "****************************************"
puts "           Vakil Search Tasks"
puts "****************************************"
puts "Task 1: Join Uniq character String\n\n"
obj.join_string(["oven", "envier", "erase", "serious"])
obj.join_string(["move", "over", "very"])
obj.join_string(["to", "ops", "psy", "syllable"])

puts "Task 2: Sudoku Validator\n\n"

input_arr = [
  [ 1, 5, 2, 4, 8, 9, 3, 7, 6 ],
  [ 7, 3, 9, 2, 5, 6, 8, 4, 1 ],
  [ 4, 6, 8, 3, 7, 1, 2, 9, 5 ],
  [ 3, 8, 7, 1, 2, 4, 6, 5, 9 ],
  [ 5, 9, 1, 7, 6, 3, 4, 2, 8 ],
  [ 2, 4, 6, 8, 9, 5, 7, 1, 3 ],
  [ 9, 1, 4, 6, 3, 7, 5, 8, 2 ],
  [ 6, 2, 5, 9, 4, 8, 1, 3, 7 ],
  [ 8, 7, 3, 5, 1, 2, 9, 6, 4 ]
]
obj.sudoku_validator(input_arr)
input_arr = [
  [ 1, 1, 2, 4, 8, 9, 3, 7, 6 ],
  [ 7, 3, 9, 2, 5, 6, 8, 4, 1 ],
  [ 4, 6, 8, 3, 7, 1, 2, 9, 5 ],
  [ 3, 8, 7, 1, 2, 4, 6, 5, 9 ],
  [ 5, 9, 1, 7, 6, 3, 4, 2, 8 ],
  [ 2, 4, 6, 8, 9, 5, 7, 1, 3 ],
  [ 9, 1, 4, 6, 3, 7, 5, 8, 2 ],
  [ 6, 2, 5, 9, 4, 8, 1, 3, 7 ],
  [ 8, 7, 3, 5, 1, 2, 9, 6, 4 ]
]
obj.sudoku_validator(input_arr)

puts "Task 3: Count of Boomerang in an Array"
obj.count_boomerang([3, 7, 3, 2, 1, 5, 1, 2, 2, -2, 2])
obj.count_boomerang([1, 7, 1, 7, 1, 7, 1])
obj.count_boomerang([9, 5, 9, 5, 1, 1, 1])
obj.count_boomerang([5, 6, 6, 7, 6, 3, 9])
obj.count_boomerang([4, 4, 4, 9, 9, 9, 9])