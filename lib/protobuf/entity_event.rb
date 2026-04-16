# frozen_string_literal: true

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "tutorial.EntityEvent" do
    optional :name, :string, 1
    optional :description, :string, 2
  end
end

module Protobuf
  EntityEvent = Google::Protobuf::DescriptorPool.generated_pool.lookup("tutorial.EntityEvent").msgclass
end
