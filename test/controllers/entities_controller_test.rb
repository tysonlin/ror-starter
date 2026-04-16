require "test_helper"

class EntitiesControllerTest < ActionDispatch::IntegrationTest
  include KafkaPublisherStubHelper

  test "should get index" do
    Entity.create!(name: "From DB", description: "seed")

    get entities_url, as: :json

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal "From DB", body.first["name"]
  end

  test "should enqueue message on create" do
    assert_no_difference -> { Entity.count } do
      with_stubbed_publisher do
        post entities_url, params: { entity: { name: "Queued", description: "later" } }, as: :json
      end
    end

    assert_response :accepted
    body = JSON.parse(response.body)
    assert_equal "queued", body["status"]
  end
end
