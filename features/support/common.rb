require_relative 'common_id'
require_relative 'common_xpath'

class Common
  include CommonModule::Id
  include CommonModule::Xpath

  def wait_true opts={}, &block
    finished = false
    tries = 0
    maxTries = opts[:maxTries]
    maxTries = 3 if maxTries.nil?
    while (!finished && tries < maxTries) do
      begin
        tries += 1
        newOpts = opts.keep_if {|k,v| k != :maxTries }
        finished = wait_true newOpts, &block
      rescue Selenium::WebDriver::Error::TimeOutError => e
        begin
          if exists {find("Try again")}
            find("Try again").click
          else
            button("OK").click
          end
        rescue
          raise e
        end
      end
    end
    finished
  end

  def import(keydata, options = {})
    GPGME::Ctx.new(options) do |ctx|
      ctx.import_keys(Data.new(keydata))
      ctx.import_result
    end
  end

  #####

  # Replaced explicit methods, with generic methods. Strategy has to be either one of:
  # :xpath, :id, :accessibility_id, :class


  def element_displayed?(element_details)
    begin
      driver.find_element(element_details).displayed?
    rescue
      false
    end
  end

  def wait_for_element(element_details)
    wait_true { element_displayed? element_details }
  end

  def get_element(element_details)
    wait_for_element element_details
    driver.find_element(element_details)
  end

  def click_element(element_details)
    get_element(element_details).click
  end

  def get_element_text(element_details)
    get_element(element_details).text
  end

  def get_element_value(element_details)
    get_element(element_details).value
  end

  def get_element_label(element_details)
    get_element(element_details).label
  end

  def get_all_elements(element_details)
    wait_for_element element_details
    driver.find_elements(element_details)
  end

  def get_all_elements_text(element_details)
    elements = get_all_elements element_details
    elements.map { |e| e.text }
  end

  def get_all_elements_text_with_scroll(element_details)
    initial = get_all_elements_text element_details
    scroll_down
    scrolled = get_all_elements_text element_details
    while scrolled.last != initial.last
      initial = initial | scrolled
      scroll_down
      scrolled = get_all_elements_text element_details
    end
    initial
  end

  def fill_in_element(element_details, text)
    wait_for_element element_details
    field = get_element element_details
    field.clear
    field.send_keys text
  end


  ######## Button Methods ########

  def button_displayed? buttonText
    exists { button(buttonText) }
  end

  def button_displayed_with_scroll buttonText
    if exists { button(buttonText) } == false
      scroll_to buttonText
    end
    exists { button(buttonText) }
  end

  def button_enabled? button
    button(button).enabled?
  end

  def wait_for_button_to_display button
    wait_true { button_displayed? button }
  end

  def click_button button
    wait_for_button_to_display button
    button(button).click
  end


  ######## Text Methods ########

  def text_displayed? text
    begin
      text(text).displayed?
    rescue
      false
    end
  end

  def wait_for_text_to_display text
    wait_true { text_displayed? text }
  end

  def click_text text
    wait_for_text_to_display text
    #click_xpath(locator.text_xpath_for text)
    text(text).click
  end

  def text_displayed_with_scroll title
    if text_displayed?(title) == false
      scroll_to title
    end
    text_displayed? title
  end

  def click_text_with_scroll title
    while text_displayed?(title) == false
      common.scroll_down
    end
    common.click_text title
  end


  ######## Scroll Methods ########

  def scroll_down
    #driver.execute_script('mobile: swipe', :startY => 0.9, :endY => 0.1)
    swipe(:start_y => 0.9,:end_y => 0.5,:start_x => 0.9, :end_x => 0.9, :duration => 800)
  end

  def scroll_up
    swipe(:start_y => 0.3,:end_y => 0.9,:start_x => 0.9, :end_x => 0.9, :duration => 800)
  end

  def scroll_right
    swipe(:start_x => 0.3,:end_x => 0.9,:start_y => 0.5, :end_y => 0.5, :duration => 800)
  end


  ######## Android KeyEvent Methods ########

  def press_device_enter_button
    press_keycode 66
  end

  def press_device_back_button
    press_keycode 4
  end

  def press_backspace
    press_keycode 67
  end

end