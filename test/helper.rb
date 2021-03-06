require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))


require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
end

require 'tyt'

def setup_season
  @pass = 'MBJ6445733' #That is actually my pass.  See how rad I am.  Do it.
  @default_season = Tyt::Bachelor::DEFAULT_SEASON
  @tyt = Tyt::Bachelor.new(pass: @pass)
end
