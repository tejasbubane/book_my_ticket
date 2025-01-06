class EventsQuery < BaseQuery
  attr_reader :current_user, :filter

  def initialize(current_user, filter)
    @current_user = current_user
    @filter = filter || {}
  end

  def call
    if filter[:created]
      current_user.created_events.recent_first
    elsif filter[:booked]
      current_user.booked_events.recent_first
    else
      Event.future.recent_first
    end
  end
end
