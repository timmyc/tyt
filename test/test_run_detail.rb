require 'helper'
require "minitest/autorun"

class RunDetail < Minitest::Test
  def setup
    @run_detail = Tyt::RunDetail.new
  end

  def test_attributes
    [:datetime, :chair, :vertical_feet, :vertical_meters].each do |attr|
      assert_respond_to @run_detail, attr
    end
  end

end
