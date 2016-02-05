# Strategy Pattern Implementation

def action
  if iphone?
    @action ||= IPhoneAction.new
  elsif ipad?
    @action ||= IPadAction.new
  elsif android?
    @action ||= AndroidAction.new
  else
    raise "Neither ios nor android are set as PLATFORM in profile. Check your profile (config/cucumber.yml) and try again."
  end
end

class IPhoneAction
  include IPhoneActions
end

class IPadAction
  include IPadActions
end

class AndroidAction
  include AndroidActions
end

def screen
  if iphone?
    @screen ||= IPhoneScreen.new
  elsif ipad?
    @screen ||= IPadScreen.new
  elsif android?
    @screen ||= AndroidScreen.new
  else
    raise "Neither ios nor android are set as PLATFORM in profile. Check your profile (config/cucumber.yml) and try again."
  end
end

class IPhoneScreen
  include IPhoneScreens
end

class IPadScreen
  include IPadScreens
end

class AndroidScreen
  include AndroidScreens
end

def helper
  @helper ||= Helper.new
end

class Helper
  include Helpers

  def initialize
    super
  end
end

def locator
  if iphone? or ipad?
    @locator ||= IosXpath.new
  elsif android? or androidtab?
    @locator ||= AndroidXpath.new
  end
end

class IosXpath
  def text_xpath_for(value)
    "//UIAStaticText[contains(@label,\"#{value}\")]"
  end

  def button_xpath_for(value)
    "//UIAButton[contains(@label,\"#{value}\")]"
  end

  def method_missing(method, *args, &block)
  raise Cucumber::Pending.new("Step not yet implemented for iPhone.")
  end
end

class AndroidXpath
  def text_xpath_for(value)
    "//android.widget.TextView[contains(@text, \"#{value}\")]"
  end

  def button_xpath_for(value)
    "//android.widget.Button[contains(@text, \"#{value}\")]"
  end

  def method_missing(method, *args, &block)
    raise Cucumber::Pending.new("Step not yet implemented for iPhone.")
  end
end