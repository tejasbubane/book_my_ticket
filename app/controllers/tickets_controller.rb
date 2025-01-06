class TicketsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    result = service.call
    if result.success?
      flash[:notice] = "#{pluralize(params[:count], "ticket")} booked successfully! Enjoy the show!"
    else
      flash[:alert] = result.failure
    end

    redirect_to event_path(params[:event_id])
  end

  private

  def service
    @service ||= TicketBookingService.new(params[:event_id], params[:count], current_user)
  end
end
