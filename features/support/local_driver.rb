require 'singleton'
require 'appium_lib'

class LocalDriver
  include Singleton

  attr_reader :driver

  def initialize
    @driver = nil
  end

  $port = ENV['PORT'] || 4723

  def create_driver(configuration)
    @location = configuration[:location]
    @capabilities = YAML.load_file(configuration_file)
  end

  def start_driver
    @driver = Appium::Driver.new(capabilities)
    Appium.promote_appium_methods Object
    Appium::Logger.level = Logger::DEBUG
  end

  def start_app
    @driver.start_driver
    set_wait 10 # Restoring implicit wait as unstable without it (some pages take some time to load)
  end

  def stop_app
    @driver.driver_quit
  end

  def restart_app
    stop_app
    start_app
  end
end
