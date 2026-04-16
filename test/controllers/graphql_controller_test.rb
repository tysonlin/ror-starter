require "test_helper"

class GraphqlControllerTest < ActionDispatch::IntegrationTest
  include KafkaPublisherStubHelper

  test "query returns entities from database" do
    Entity.create!(name: "Graph", description: "QL")

    post graphql_url, params: { query: "{ entities { name description } }" }, as: :json

    assert_response :success
    data = JSON.parse(response.body).dig("data", "entities")
    assert_equal "Graph", data.first["name"]
  end

  test "mutation enqueues create event" do
    mutation = <<~GRAPHQL
      mutation {
        createEntity(input: { name: "Queued", description: "Through GraphQL" }) {
          status
        }
      }
    GRAPHQL

    assert_no_difference -> { Entity.count } do
      with_stubbed_publisher do
        post graphql_url, params: { query: mutation }, as: :json
      end
    end

    assert_response :success
    assert_equal "queued", JSON.parse(response.body).dig("data", "createEntity", "status")
  end
end
