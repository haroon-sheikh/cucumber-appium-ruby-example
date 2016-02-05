module Helpers
  def get_android_version
    android_version = `adb -s #{ENV['udid']} shell getprop ro.build.version.release`
    android_version.to_f
  end

  def can_screenrecord?
    if ENV['udid'] && should_record? && android? && get_android_version >= 4.4
      true
    else
      false
    end
  end

  def start_screenrecording scenario_name
    $vid_scenario_name = cleanse_scenario_name scenario_name
    $screenrecord_pid = Process.spawn("adb -s #{ENV['udid']} shell screenrecord --bit-rate 200000 /sdcard/VID_#{$vid_scenario_name}.mp4")
  end

  def pull_and_delete_screenrecord
    kill_screenrecord_process
    `adb -s #{ENV['udid']} pull /sdcard/VID_#{$vid_scenario_name}.mp4`
    `adb -s #{ENV['udid']} shell rm -Rf /sdcard/VID_#{$vid_scenario_name}.mp4`
  end

  def delete_screen_record
    kill_screenrecord_process
    `adb -s #{ENV['udid']} shell rm -Rf /sdcard/VID_#{$vid_scenario_name}.mp4`
  end

  def kill_screenrecord_process
    Process.kill("HUP", $screenrecord_pid)
    sleep 1
  end

  def cleanse_scenario_name s
    s = s.tr(' ', '_')
    s = s.tr('(', '')
    s = s.tr(')', '')
    s = s.tr(',', '')
    s = s.tr('|', '_')
    s = s.tr('/', '_')
    return s
  end
end