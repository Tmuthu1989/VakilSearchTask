module ApplicationHelper
  include ActiveLinkToHelper
  include TemplateNavHelper

  def serving_states(f)
  	states = current_user.senior_lawyer? ? State.pluck(:name, :id) : current_user.senior&.states.pluck(:name, :id)
  	states ||= []
  	f.select :state_ids, options_for_select(states, current_user.state_ids), {}, {class: "chosen-select form-control", required: true, multiple: true}
  end
end
