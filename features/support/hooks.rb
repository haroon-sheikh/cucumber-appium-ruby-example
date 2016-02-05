require_relative '../properties/environments'
require_relative '../properties/run_properties'
require_relative '../../features/properties/ios_devices'

Before do |s|
  helper.clear_logcat if helper.can_use_adb
  helper.start_appium(appium_params) if start_appium?

  if $driver_created
    LocalDriver.instance.start_app
  else
    prepare_driver
    $driver_created = true
  end

  helper.start_screenrecording(s.name) if helper.can_screenrecord?
end

After do |s|
  if s.failed?
    dir = `pwd`.strip
    helper.get_ui_dump(s.name) if helper.can_use_adb
    screenshot "#{dir}/FAIL_#{s.name}.png"
    embed("FAIL_#{s.name}.png", 'image/png', 'SCREENSHOT')
    helper.save_logcat(s.name) if helper.can_use_adb
    helper.pull_and_delete_screenrecord if helper.can_screenrecord?
  else
    helper.delete_screen_record if helper.can_screenrecord?
  end

  LocalDriver.instance.stop_app

  helper.kill_appium if start_appium?
end

def prepare_driver
  @configuration = { props: props, location: prepare_location }
  if android?
    prepare_android
  elsif ios?
    prepare_ios
  end
  @local_driver.create_driver(@configuration)
  @local_driver.start_driver
end

def prepare_ios
  if simulator?
    @configuration[:execution_device] = RunProperties::SIMULATOR
  else
    @configuration[:execution_device] = RunProperties::DEVICE
  end
  if ipad?
    @configuration[:device] = IosDevices::IPAD
  elsif iphone?
    @configuration[:device] = IosDevices::IPHONE
  else
    fail ArgumentError, 'Please specify the phone type'
  end
end

def prepare_android
  @configuration[:package] = ENV[Environments::PACKAGE]
  @configuration[:port] = port
  @local_driver = AndroidDriver.instance
end