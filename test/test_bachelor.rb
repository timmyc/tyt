require 'helper'
require "minitest/autorun"

class TestBachelor < Minitest::Test
  def setup
    @pass = 'MBJ6445733' #That is actually my pass.  See how rad I am.  Do it.
    @default_season = Tyt::Bachelor::DEFAULT_SEASON
    @tyt = Tyt::Bachelor.new(pass: @pass)
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
end
