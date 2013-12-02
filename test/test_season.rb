require 'helper'
require "minitest/autorun"

class TestSeason < Minitest::Test
  def setup
    @season = Tyt::Season.new
    setup_season
    @tyt.season = '12-13'
  end

  def test_attributes
    [:name, :days].each do |attr|
      assert_respond_to @season, attr
    end
  end

  def test_total_runs
    assert_respond_to @season, :total_runs
    VCR.use_cassette('12_13_season_page') do
      season = @tyt.season_data
      assert season.total_runs == 204
    end
  end

  def test_total_days
    assert_respond_to @season, :total_days
    VCR.use_cassette('12_13_season_page') do
      season = @tyt.season_data
      assert season.total_days == 29
    end
  end

  def test_total_vertical_feet
    assert_respond_to @season, :total_vertical_feet
    VCR.use_cassette('12_13_season_page') do
      season = @tyt.season_data
      total_vert = season.total_vertical_feet
      assert total_vert == 268711, "Expect total_vertical_feet to be 268711 got #{total_vert}"
    end
  end

  def test_total_vertical_meters
    assert_respond_to @season, :total_vertical_meters
    VCR.use_cassette('12_13_season_page') do
      season = @tyt.season_data
      total_meters = season.total_vertical_meters
      assert total_meters == 81818, "Expect total_vertical_meters to be 81818 got #{total_meters}"
    end
  end

end
