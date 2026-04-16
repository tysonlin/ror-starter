# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_entity, mutation: Mutations::CreateEntity
  end
end
