class TicketsController < ApplicationController
  def create
    if event.can_book?(params[:count])
      Ticket.insert_all(ticket_params)

      flash[:notice] = "#{params[:count]} tickets booked successfully! Enjoy the show!"
    else
      flash[:alert] = "Invalid email or password."
    end
    redirect_to event_path(event)
  end

  private

  def event
    @event = Event.find(params[:event_id])
  end

  def ticket_params
    params[:count].to_i.times.map { { event_id: params[:event_id], user_id: current_user.id } }
  end
end
