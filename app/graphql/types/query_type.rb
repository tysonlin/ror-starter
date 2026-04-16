# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # GraphQL field resolvers are Ruby methods, which keeps schema and code tightly aligned.
    field :entities, [Types::EntityType], null: false

    def entities
      Entity.order(created_at: :desc)
    end
  end
end
