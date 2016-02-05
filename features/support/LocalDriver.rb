require 'singleton'
require 'appium_lib'

class LocalDriver
  include Singleton

  attr_reader :driver

  def initialize
    @driver=nil
  end

  $port = ENV['PORT']  || 4723

  def create_driver
    if android?
      if app_parameter?
         @app = ENV['apk']
         ENV['package'] ? $package = ENV['package'] : raise("You need to provide package as a parameter as well!")
      elsif local?
         @app=$props['app_url']['android_local']["#$package"]
      elsif external?
         @app=$props['app_url']['android_external']["#$package"]
      end

      @capabilities = {
          caps: {
              'platformName' => 'Android',
              'deviceName' => 'Android',
              'browserName' => '',
              'version' => "4.2",
              'app' => @app,
              'appPackage' => $package,
              'appActivity' => "", # TODO: Put the launcheable activity of your app here
              'newCommandTimeout' => 300
          },
          appium_lib: {
              'port' => $port
          }
      }

    elsif (iphone? || ipad?)
      if app_parameter?
        @app = ENV['ipa']
      elsif local?
        if simulator?
          @app=$props['app_url']['ios_local']['ios_simulator']
        elsif device?
          @app=$props['app_url']['ios_local']['ios_device']
        end
      elsif external?
        if simulator?
          @app=$props['app_url']['ios_external']['ios_simulator']
        elsif device?
          @app=$props['app_url']['ios_external']['ios_device']
        end
      end

      if iphone?
        @device='iPhone 5s'
      elsif ipad?
        @device='ipad'
      end

      @capabilities = {
          caps: {
              'autoLaunch' => true,
              'browserName' => '',
              'version' => '7.1',
              'platformName' => 'iOS',
              'deviceName' => @device,
              'app' => @app,
              'newCommandTimeout' => 300,
              'autoAcceptAlerts' => false,
              'keepKeyChains' => false
          }
      }
   end

    @driver = Appium::Driver.new(@capabilities)
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