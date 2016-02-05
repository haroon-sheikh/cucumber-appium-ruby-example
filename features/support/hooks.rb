Before do |s|
  helper.clear_logcat if helper.can_use_adb
  helper.start_appium(appium_params) if start_appium?

  if $driver_created
    LocalDriver.instance.start_app
  else
    prepare_driver
    LocalDriver.instance.create_driver
    LocalDriver.instance.start_app
    $driver_created = true
  end

  helper.start_screenrecording(s.name) if helper.can_screenrecord?
end

After do |s|
  if s.failed?
    dir=`pwd`.strip
    helper.get_ui_dump(s.name) if helper.can_use_adb
    screenshot "#{dir}/FAIL_#{s.name}.png"
    embed("FAIL_#{s.name}.png", "image/png", "SCREENSHOT")
    helper.save_logcat(s.name) if helper.can_use_adb
    helper.pull_and_delete_screenrecord if helper.can_screenrecord?
  else
    helper.delete_screen_record if helper.can_screenrecord?
  end

  LocalDriver.instance.stop_app

  helper.kill_appium if start_appium?
end

private

require_relative '../properties/location_properties'

def prepare_driver
  if android?
    @local_driver = AndroidDriver.instance
    @local_driver.create_driver(package, props, prepare_location)
  end
end

def prepare_location
  if app_parameter?
    LocationProperties::APP
  elsif external?
    LocationProperties::EXTERNAL
  elsif local?
    LocationProperties::LOCAL
  else
    fail('Application execution parameter has to be added')
  end
end