require 'helper'
require "minitest/autorun"

class TestBachelor < Minitest::Test
  def setup
    setup_season
  end

  def test_that_pass_is_required
    assert_raises(ArgumentError){ Tyt::Bachelor.new }
  end

  def test_that_pass_is_set
    assert @tyt.pass == @pass
  end

  def test_that_season_is_set
    assert_respond_to @tyt, :season
    assert @tyt.season == @default_season
  end

  def test_that_mtb_endpoint_is_set
    assert_respond_to @tyt, :mtb_endpoint
    assert @tyt.mtb_endpoint == Tyt::Bachelor::MTB_ENDPOINT
  end

  def test_that_season_can_be_set
    @tyt = Tyt::Bachelor.new(pass: @pass, season: '12-13')
    assert @tyt.season == '12-13', 'Season should be set to 12-13'
  end

  def test_that_season_must_be_in_yy_yy_format
    assert_raises(ArgumentError){ Tyt::Bachelor.new(pass: @pass, season: '1213') }
  end

  def test_that_data_endpoint_is_correct
    expected_endpoint = "#{Tyt::Bachelor::MTB_ENDPOINT}?passmediacode=#{@pass}&season=#{@tyt.season}&currentday=null"
    assert @tyt.data_endpoint == expected_endpoint, "expected #{expected_endpoint} got #{@tyt.data_endpoint}"
  end

  def test_that_get_doc_populates_doc
    @tyt.season = '12-13'
    VCR.use_cassette('12_13_season_page') do
      @tyt.get_doc
      assert @tyt.doc.instance_of?(Nokogiri::HTML::Document) == true
    end
  end

  def test_that_get_season_returns_season
    @tyt.season = '12-13'
    VCR.use_cassette('12_13_season_page') do
      season_data = @tyt.season_data
      assert season_data.instance_of?(Tyt::Season)
    end
  end

  def test_that_get_season_day_sets_right_data
    @tyt.season = '12-13'
    VCR.use_cassette('12_13_season_page') do
      season_data = @tyt.season_data
      opening_day = season_data.days.first
      assert opening_day.runs == 4, "runs expected 4 got #{opening_day.runs}"
      assert opening_day.vertical_feet == 1028, "vertical_feet expected 1028 got #{opening_day.vertical_feet}"
      assert opening_day.vertical_meters == 312, "vertical_meters expected 312 got #{opening_day.vertical_meters}"
    end
  end

  def test_that_date_data_returns_array
    @tyt.season = '12-13'
    date = Date.strptime('04/13/2013', '%m/%d/%Y')
    VCR.use_cassette('04-13-13_date_page') do
      date_data = @tyt.date_data(date)
      assert date_data.instance_of?(Array)
    end
  end

  def test_that_date_data_sets_right_data
    @tyt.season = '12-13'
    date = Date.strptime('04/13/2013', '%m/%d/%Y')
    VCR.use_cassette('04-13-13_date_page') do
      date_data = @tyt.date_data(date)
      first_run = date_data[0]
      assert first_run.chair == 'Sunshine'
      assert first_run.vertical_feet == 257
      assert first_run.vertical_meters == 78
      assert first_run.datetime.strftime('%m/%d/%Y %l:%M:%S %p') == '04/13/2013  9:40:05 AM'
    end
  end

  def test_that_date_data_supports_one_digit_hours
    date = Date.strptime('12/05/2013', '%m/%d/%Y')
    VCR.use_cassette('12-05-13_date_page') do
      date_data = @tyt.date_data(date)
      assert date_data.length == 9
    end
  end

  def test_that_date_with_no_data_returns_nil
    @tyt.season = '12-13'
    date = Date.strptime('04/14/2013', '%m/%d/%Y')
    VCR.use_cassette('04-14-13_date_page') do
      date_data = @tyt.date_data(date)
      assert date_data == nil
    end
  end
end
