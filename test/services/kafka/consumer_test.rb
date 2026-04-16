require "test_helper"
require "protobuf/entity_event"

class KafkaConsumerTest < ActiveSupport::TestCase
  test "process_message writes payload to database" do
    payload = Protobuf::EntityEvent.new(name: "From Kafka", description: "persist me").to_proto

    assert_difference -> { Entity.count }, 1 do
      KafkaIntegration::Consumer.new.process_message(payload)
    end

    assert_equal "From Kafka", Entity.order(:created_at).last.name
  end
end
