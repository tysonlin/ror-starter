require "test_helper"

class EntityTest < ActiveSupport::TestCase
  test "name is required" do
    entity = Entity.new(description: "missing name")

    assert_not entity.valid?
    assert_includes entity.errors[:name], "can't be blank"
  end
end
