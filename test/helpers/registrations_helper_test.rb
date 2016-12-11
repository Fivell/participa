require 'test_helper'

#
# Tests countries, provinces & regions through Carmen
#
class RegistrationsHelperTest < ActionView::TestCase

  test "get_countries gets us all countries" do
    assert_equal 249, get_countries.size
  end

  test "get_provinces gets all provinces for a specific country" do
    assert_equal 52, get_provinces("ES").size
  end

  test "get_towns gets towns for a specific province" do
    barna_towns = get_towns("ES", "B").map(&:name)

    assert_includes barna_towns, "Barcelona"
    assert_includes barna_towns, "Terrassa"
    assert_includes barna_towns, "Sabadell"
  end

end
