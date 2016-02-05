require 'rspec'
require 'rspec/expectations'
World(RSpec::Matchers)
require 'pry'
require 'pry-nav'
require 'json'
require 'open-uri'
require 'selenium-webdriver'
require 'active_support/all'
require 'cucumber/ast'
require 'test/unit/assertions'
include RSpec::Matchers
include Test::Unit::Assertions

$package = "" # TODO: Put your android app package here, e.g. com.google.app.app

# Shit hotfix for starting tests with paramaterized apk and package
$package = ENV['package'] if ENV['package']

$id_prefix = "#{$package}:id/"

puts $package

$props ||= YAML::load_file('./features/support/props.yml')

def simulator?
  ENV['SIMULATOR'] == 'true'
end

def device?
  !simulator?
end

def iphone?
  ENV['DEVICE'] == 'iphone'
end

def ipad?
  ENV['DEVICE'] == 'ipad'
end

def external?
  ENV['AppLocation'] == 'external'
end

def local?
  ENV['AppLocation'] == 'local'
end

def apk_parameter?
  ENV['apk']
end

def ipa_parameter?
  ENV['ipa']
end

def android?
  ENV['DEVICE'] == 'android'
end

def androidtab?
  ENV['DEVICE'] == 'androidtab'
end

def should_record?
  ENV['recordScreen'] == 'true'
end

def start_appium?
  ENV['START_APPIUM'] == 'true'
end

def appium_params
  ENV['APPIUM_PARAMETERS']
end

def driver
  Driver.instance.driver
end

def wait
  #@wait ||= Appium::LocalDriver::Wait.new(:timeout => 30)
  @wait ||= driver.manage.timeouts.implicit_wait = 90
end

def common
  @common ||= Common.new
end



