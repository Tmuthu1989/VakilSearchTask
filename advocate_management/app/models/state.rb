class State < ApplicationRecord
	def State.load_states
		states = []
		CS.states(:in).each do |code, state|
			states << {code: code.to_s, name: state}
		end
		State.create(states)
	end
end
