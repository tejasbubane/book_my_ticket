class TicketBookingService < BaseService
  attr_reader :event_id, :count, :current_user

  def initialize(event_id, count, current_user)
    @event_id = event_id
    @count = count.to_i
    @current_user = current_user
  end

  def call
    event = yield find_event

    ApplicationRecord.transaction do
      Ticket.insert_all(ticket_params)
      event.increment(:sold_tickets_count, count).save!
      Success(event)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
      Failure(e.message)
    end
  end

  private

  def find_event
    event = Event.find_by(id: event_id)

    return Failure("Event with ID #{event_id} not found") unless event.present?
    return Failure("Sorry, requested quantity of tickets are not available") unless event.can_book?(count)

    Success(event)
  end

  def ticket_params
    count.times.map { { event_id: event_id, user_id: current_user.id } }
  end
end
