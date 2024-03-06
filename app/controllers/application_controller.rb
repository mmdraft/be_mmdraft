class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  # around_action :set_time_zone, if: :current_user

  private

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def render_not_found_response(exception)
    render json: { errors: { detail: exception.message } }, status: :not_found
  end

  def render_unprocessable_entity_response(exception)
    render json: { errors: { detail: exception.record.errors.full_messages.join(', ') } }, status: :unprocessable_entity
  end
end
