class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.future
  end

  def new
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.expect(event: %i[name description location starts_at total_tickets_count])
          .merge(creator_id: current_user.id)
  end
end
