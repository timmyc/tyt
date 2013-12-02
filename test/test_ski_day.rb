require 'helper'
require "minitest/autorun"

class TestSkiDay < Minitest::Test
  def setup
    @ski_day = Tyt::SkiDay.new
  end

  def test_attributes
    [:date, :runs, :vertical_feet, :vertical_meters].each do |attr|
      assert_respond_to @ski_day, attr
    end
  end

end
