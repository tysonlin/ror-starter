# frozen_string_literal: true

module Mutations
  class CreateEntity < BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false

    field :status, String, null: false

    def resolve(name:, description: nil)
      payload = { name: name, description: description }
      KafkaIntegration::Publisher.publish_entity_created(payload)
      { status: "queued" }
    rescue StandardError => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
