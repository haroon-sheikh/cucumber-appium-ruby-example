require 'yaml'
require_relative '../local_driver'
require_relative '../../properties/run_properties'
require_relative '../../../features/properties/environments'

class AndroidDriver < LocalDriver
  attr_reader :capabilities

  ANDROID_CONFIGURATION_FILE = File.join(File.dirname(__FILE__), '../../properties/capabilities/android_capabilities.yml')

  def create_driver(configuration)
    super
    set_package
    prepare_location(configuration[:props])
    prepare_capabilities(configuration[:port])
  end

  def configuration_file
    ANDROID_CONFIGURATION_FILE
  end

  def prepare_location(props)
    case @location
    when RunProperties::APP
      @app = ENV[Environments::APK]
    when RunProperties::LOCAL
      @app = props[Environments::APP_URL][Environments::ANDROID_LOCAL]["#{@package}"]
    when RunProperties::EXTERNAL
      @app = props[Environments::APP_URL][Environments::ANDROID_EXTERNAL]["#{@package}"]
    else
      fail ArgumentError, 'Please Provide a Location'
    end
  end

  def prepare_capabilities(port)
    @capabilities[:caps][:app] = @app
    @capabilities[:caps][:package] = @package
    @capabilities[:appium_lib] = { port: port }
  end

  def set_package
    package_environment = ENV[Environments::PACKAGE]
    package_from_yaml = @capabilities[:caps][:package]
    if package_environment.nil?
      @package = package_environment
    elsif package_from_yaml != ''
      @package = package_from_yaml
    else
      fail ArgumentError, 'Please enter a package'
    end
  end
end