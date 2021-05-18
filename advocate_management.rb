require 'rubygems'
require 'json'
class AdvocateManagement
	attr_accessor :advocates, :cases, :is_continue, :advocate_obj, :senior_advocates, :case_obj, :blocked_cases
	def initialize
		puts "******************************************************"
		puts "               Advocate Management System             "
		puts "******************************************************"
		@data = {}
		if File.exist?("advocate_management.json")
			@data = JSON.parse(File.read("advocate_management.json"))
		else
			File.open("advocate_management.json","w") { |f| f.write({}.to_json) }
		end
		self.advocates = !@data["advocates"].nil? ? @data["advocates"] : {}
		self.cases = !@data["cases"].nil? ? @data["cases"] : {}
		self.blocked_cases = !@data["blocked_cases"].nil? ? @data["blocked_cases"] : {}
		self.senior_advocates = !@data["senior_advocates"].nil? ? @data["senior_advocates"] : []
		self.is_continue = true
		self.advocate_obj = {
			"id" => nil, 
			"name" => nil, 
			"cases" => [], 
			"states" => [], 
			"juniors" => [],
			"senior_id" => nil, 
			"blocked_cases" => [], 
			"advocate_type" => nil
		}
		self.case_obj = {"id" => nil, "name" => nil, "state" => nil}
		
	end	

	def start
		while is_continue
			puts "-----------------------------------------------------"
			puts "System Options:"
			puts "-----------------------------------------------------"
			puts "1. Add an Advocate"
			puts "2. Add Junior Advocates"
			puts "3. Add States for Advocate"
			puts "4. Add Cases for Advocate"
			puts "5. Reject a Case"
			puts "6. Display All Advocates"
			puts "7. Display All cases under a State"
			puts "8. Exit from application"
			puts "-----------------------------------------------------"
			puts "Note: Ex: Enter 1 for adding an advocate"
			puts "-----------------------------------------------------"
			sys_option = get_input?("Please Enter an option from the list: ").to_i
			case sys_option
			when 1
				puts "-----------------------------------------------------"
				puts "Adding an Advocate:"
				puts "-----------------------------------------------------"
				add_an_advocate
				puts "-----------------------------------------------------\n\n"
			when 2
				puts "-----------------------------------------------------"
				puts "               Adding Junior Advocate                "
				puts "-----------------------------------------------------"
				add_junior_advocate
			when 3
				puts "-----------------------------------------------------"
				puts "             Adding States for Advocate              "
				puts "-----------------------------------------------------"
				add_state_for_advocate
				puts "-----------------------------------------------------"
			when 4
				puts "-----------------------------------------------------"
				puts "              Adding Cases for Advocates             "
				puts "-----------------------------------------------------"
				add_case_for_advocate
				puts "-----------------------------------------------------"
			when 5
				puts "-----------------------------------------------------"
				puts "            Rejecting Case for Advocates             "
				puts "-----------------------------------------------------"
				reject_case
				puts "-----------------------------------------------------"
			when 6
				puts "-----------------------------------------------------"
				puts "            Displaying Available Advocates           "
				puts "-----------------------------------------------------"
				display_all_advocates
			when 7
				puts "-----------------------------------------------------"
				puts "        Displaying Available Cases for State         "
				puts "-----------------------------------------------------"
				display_all_cases_for_state
			when 8
				puts "Are you sure you want to exit?(Default: Yes)"
				puts "1. Yes    2. No"
				is_continue = gets.chomp.to_i == 2 ? true : false
				if !is_continue
					update_data
					puts "******************************************************************"
					puts "  Thank you for using Advocate Management System! See you again"	
					puts "******************************************************************"
					break
				end
			else
				puts "Invalid Input"
			end
			update_data
			puts "\n"
		end
	end

	def add_an_advocate
		advocate = @advocate_obj.dup
		advocate["id"] = get_input?("Enter Advocate Number:")
		if @advocates[advocate["id"].to_s].nil?
			advocate["name"] = get_input?("Enter Advocate name:")
			advocate["advocate_type"] = get_input?("Enter Advocate Type: 1) Senior   2) Junior :").to_i == 1 ? "Senior" : "Junior" 
			@advocates[advocate["id"].to_s] = advocate
			@senior_advocates << advocate["id"].to_s if advocate["advocate_type"].to_s == "Senior"
			puts "Advocate Added Successfully!"
		else
			puts "Advocate is already added. Please try again"
			add_an_advocate
		end
	end

	def add_junior_advocate
		senior = @advocates[get_input?("Enter Senior ID:").to_s]
		junior = @advocates[get_input?("Enter Junior ID:").to_s]
		if senior.nil? || junior.nil?
			puts "Invalid Input!"
			puts "Senior is not exist" if senior.nil?
			puts "Junior is not exist" if junior.nil?
			add_junior_advocate
		end
		if senior["id"] != junior["id"]
			if @senior_advocates.include? senior["id"]
				if senior["juniors"].include?(junior["id"])
					puts "Junior #{junior["name"]}(#{junior["id"]}) is already exist under #{senior["name"]}(#{senior["id"]})"
				else
					senior["juniors"] << junior["id"]
					junior["senior_id"] = senior["id"]
					junior["advocate_type"] = "Junior"
					@senior_advocates.delete(junior["id"])
					@advocates[senior["id"]] = senior
					@advocates[junior["id"]] = junior
				end
			else
				puts "Invalid Senior ID! Please try again!"
				add_junior_advocate
			end
		else
			puts "Senior Id & Junior Id should not be the same!"
			add_junior_advocate
		end
	end

	def add_state_for_advocate
		advocate = @advocates[get_input?("Enter Advocate ID:").to_s]
		if advocate.nil?
			puts "Invalid Advocate ID. Please try again!\n\n"
			add_state_for_advocate
		else
			senior_states = advocate["senior_id"].nil? ? [] : @advocates[advocate["senior_id"]]["states"]
			state = get_input?("Enter Practicing State:")
			if advocate["states"].include?(state)
				puts "State already exist!"
			else
				if senior_states.empty? || (!senior_states.empty? && senior_states.include?(state))
					advocate["states"] << state
					puts "State #{state} has been added to Advocate #{advocate["name"]}(#{advocate["id"]})"
				else
					puts "You cannot add this state! Please enter only these states: #{senior_states.join(",")}"
					add_state_for_advocate
				end
			end
		end		
	end

	def add_case_for_advocate
		advocate = @advocates[get_input?("Enter Advocate ID:").to_s]
		if advocate.nil?
			puts "Invalid Advocate ID. Please try again!\n\n"
			add_case_for_advocate
		else
			case_id = get_input?("Enter Case ID:")
			if @cases[case_id].nil?
				state = get_input?("Enter Case state:")
				senior = !advocate["senior_id"].nil? ? @advocates[advocate["senior_id"]] : nil
				if !senior.nil? && senior["blocked_cases"].include?(case_id)
					puts "Your Senior has been put this case as blocked! So you cannot add!" 
				elsif advocate["states"].include?(state)
					@cases[case_id] = {"id" => case_id, "advocate_id" => advocate["id"], "state" => state}
					advocate["cases"] << case_id
					@advocates[advocate["id"]] = advocate
					if !senior.nil?
						senior["cases"] << case_id
						@advocates[senior["id"]] = senior
					end
					puts "Case #{case_id} has been added under #{advocate["name"]} and the state is #{state}"
				else
					puts "You cannot add this case, because of state not belongs to your practicing states"
				end
			else
				puts "Case already exist! Please try again!"
				add_case_for_advocate
			end
		end	
	end

	def reject_case
		advocate = @advocates[get_input?("Enter Advocate ID:").to_s]
		if advocate.nil?
			puts "Invalid Advocate ID. Please try again!\n\n"
			reject_case
		else
			case_id = get_input?("Enter Case ID:")
			if advocate["cases"].include?(case_id)
				is_confirm = get_input?("Are you sure you want to reject this case? 1. Yes   2. No")
				if is_confirm.to_i == 1
					advocate["cases"].delete
					advocate["blocked_cases"] << case_id
					@blocked_cases[case_id] = @cases[case_id]
					@cases.delete(case_id)
					puts "Case #{case_id} is added to block list for #{advocate["name"]}(#{advocate["id"]})"		
				else
					puts "Case not rejected!"
				end	
			else
				puts "Invalid Case Id! Please try again!"
				reject_case
			end
		end
	end

	def display_all_advocates
		
		i = 0
		@advocates.values.each do |advocate, ind|
			puts "Advocate #{i+=1}"
			puts "----------"
			puts "Advocate ID\t\t: #{advocate["id"]}"
			puts "Name\t\t\t: #{advocate["name"]}"
			puts "Type\t\t\t: #{advocate["advocate_type"]}"
			puts "Senior Name\t\t: #{@advocates[advocate["senior_id"]]["name"]}" if !advocate["senior_id"].nil? 
			puts "States\t\t\t: #{advocate["states"].join(", ")}" if !advocate["states"].empty?
			puts "Cases\t\t\t:" if !advocate["cases"].empty?
			get_cases(advocate["cases"]).each_with_index do |case_det, c_ind|
				puts "\tCase #{c_ind+1}"
				puts "\t---------------------------"
				puts "\tID: #{case_det["id"]}"
				puts "\tState: #{case_det["state"].to_s}"
				puts "\t---------------------------"
			end
			puts "-----------------------------------------------------\n\n"
		end
	end

	def display_all_cases_for_state
		state = get_input?("Enter State:")
		cases_list = get_cases([], state)
		if cases_list.empty?
			puts "No Cases Found for #{state}!"
		else
			puts "-----------------------------------------------"
			puts "                  Cases List                   "
			puts "-----------------------------------------------"
			cases_list.each_with_index do |case_det, c_ind|
				puts "Case #{c_ind+1}"
				puts "---------------------------"
				puts "ID: #{case_det["id"]}"
				puts "State: #{case_det["state"].to_s}"
				puts "---------------------------"
			end
		end
		puts "-----------------------------------------------------\n\n"
	end

	private
		def get_input?(input_text)
			puts input_text
			input_val = gets.chomp
			if input_val.to_s.empty?
				puts "Invalid input! Please try again!"
				get_input?(input_text) 
			end
			return input_val
		end

		def get_cases(case_ids=[], state_id=nil)
			cases_list = []
			cases.each do |case_id, case_det|
				cases_list << case_det if !case_ids.empty? && case_ids.include?(case_det["id"])
				cases_list << case_det if !state_id.nil? && state_id.to_s == case_det["state"].to_s
			end
			cases_list
		end

		def advocate_presence?(advocate)
			!@advocates[advocate.to_s].nil?
		end

		def update_data
			@data = {advocates: @advocates, cases: @cases, senior_advocates: @senior_advocates}
			File.open("advocate_management.json","w") do |f|
				f.write(@data.to_json)
			end
		end

end

AdvocateManagement.new.start