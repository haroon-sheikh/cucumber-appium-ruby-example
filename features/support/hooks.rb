Before do |s|
  helper.clear_logcat if helper.can_use_adb
  helper.start_appium(appium_params) if start_appium?

  if $driver_created
    LocalDriver.instance.start_app
  else
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