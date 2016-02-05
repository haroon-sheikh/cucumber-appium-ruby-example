module Helpers
  def can_use_adb
    if ENV['udid'] && android?
      true
    else
      false
    end
  end

  def clear_logcat
    `adb -s #{ENV['udid']} logcat -c`
  end

  def save_logcat full_scenario_name
    scenario_name = helper.cleanse_scenario_name full_scenario_name
    output_full_logcat scenario_name
  end

  def output_specific_logcat scenario_name
    app_pid = `adb -s #{ENV['udid']} shell ps | grep #{$package} | cut -c10-15`.strip
    `adb -s #{ENV['udid']} logcat -d | grep #{app_pid} > #{"LOGCAT_APP_"+scenario_name.tr(' ', '_')}.txt`
  end

  def output_full_logcat scenario_name
    `adb -s #{ENV['udid']} logcat -d > #{"LOGCAT_"+scenario_name.tr(' ', '_')}.txt`
  end

  def get_ui_dump full_scenario_name
    scenario_name = helper.cleanse_scenario_name full_scenario_name

    output = File.open( "UIDUMP_#{scenario_name}.xml","w" )
    output << get_source
    output.close
  end

end