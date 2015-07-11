class Request < ActiveRecord::Base
  serialize :data, JSON

  scope :all_for_trap, ->(trap) { where(trap: trap).order(created_at: :desc) }
end
