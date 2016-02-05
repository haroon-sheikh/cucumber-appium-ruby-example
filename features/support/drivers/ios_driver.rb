require 'yaml'
require_relative '../local_driver'
require_relative '../../properties/run_properties'
require_relative '../../properties/environments'

class IosDriver < LocalDriver
  attr_reader :capabilities

  IOS_CONFIGURATION_FILE = File.join(File.dirname(__FILE__), '../../properties/capabilities/ios_capabilities.yml')

  def create_driver(configuration)
    super
    @execution_device = configuration[:execution_device]
    prepare_location(configuration[:props])
    prepare_capabilities(configuration[:device])
    @capabilities
  end

  def configuration_file
    IOS_CONFIGURATION_FILE
  end

  def prepare_location(props)
    case @location
    when RunProperties::APP
      @app = ENV[Environments::IPA]
    when RunProperties::LOCAL
      @app = props[Environments::APP_URL][Environments::IOS_LOCAL][@execution_device]
    when RunProperties::EXTERNAL
      @app = props[Environments::APP_URL][Environments::IOS_EXTERNAL][@execution_device]
    else
      fail ArgumentError, 'Please Provide a Location'
    end
  end

  def prepare_capabilities(device)
    @capabilities[:caps][:app] = @app
    @capabilities[:caps][:device] = device
  end
end