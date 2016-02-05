module Helpers
  def start_appium appium_params = nil
    kill_appium_on_port appium_params

    appium_command="appium --full-reset #{appium_params}"
    puts "Appium Command: #{appium_command}"
    $appium_pid = Process.spawn(appium_command)
    puts "Appium has been started with PID #{$appium_pid}"
    sleep 20
  end

  def kill_appium
    Process.kill("HUP", $appium_pid)
    puts "Appium with PID #{$appium_pid} has been killed"
  end

  def get_appium_param_port appium_params

  end

  def kill_appium_on_port appium_params
    begin
      port = appium_params[/-p\s\d+/].delete("-p ").to_i

      puts "!!!!! Getting Appium PID from PORT"
      pid = `lsof -t -i:#{port}`

      puts "!!!!! Appium PID we're going to kill is #{pid}"
      `kill -9 #{pid}`
      puts "!!!!! Appium with PID #{pid} has been killed"
    rescue
      puts "Unable to get appium port. Maybe it wasn't set"
    end
  end

end