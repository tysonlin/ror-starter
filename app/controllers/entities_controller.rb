class EntitiesController < ApplicationController
  def index
    # Active Record models map Ruby objects to rows in the database.
    render json: Entity.order(created_at: :desc)
  end

  def create
    payload = entity_params.to_h
    KafkaIntegration::Publisher.publish_entity_created(payload)

    # API-only apps often return 202 for async workflows handled by workers/consumers.
    render json: { status: "queued", entity: payload }, status: :accepted
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  # Strong Parameters are a Rails safety pattern that whitelists accepted fields.
  def entity_params
    params.require(:entity).permit(:name, :description)
  end
end
