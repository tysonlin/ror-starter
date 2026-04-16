ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module KafkaPublisherStubHelper
  def with_stubbed_publisher
    singleton = KafkaIntegration::Publisher.singleton_class
    original = KafkaIntegration::Publisher.method(:publish_entity_created)
    singleton.define_method(:publish_entity_created) { |_payload| true }
    yield
  ensure
    singleton.define_method(:publish_entity_created, original)
  end
end
