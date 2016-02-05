class Common

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
          elm = find "Try again"
          elm.click
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
  def xpath_exists? xpath
    driver.find_elements(:xpath, xpath).count>0
  end

  def xpath_displayed? xpath
    begin
      driver.find_element(:xpath, xpath).displayed?
    rescue
      return false
    end
  end

  def xpath_enabled? xpath
    wait_for_xpath_to_display xpath
    #sleep 6
    driver.find_element(:xpath, xpath).enabled?
  end

  def xpath_present? xpath
    begin
      driver.find_element(:xpath, xpath).present?
    rescue
      return false
    end
  end

  def wait_for_xpath_to_display xpath
    wait_true { xpath_displayed? xpath }
  end

  def wait_for_name_to_display name
    wait_true { name_displayed? name }
  end

  def click_xpath xpath
    wait_for_xpath_to_display xpath
    sleep 2
    driver.find_element(:xpath, xpath).click
  end

  def click_xpath_quickly xpath
    wait_for_xpath_to_display xpath
    driver.find_element(:xpath, xpath).click
  end

  def get_xpath_text xpath
    wait_for_xpath_to_display xpath
    driver.find_element(:xpath, xpath).text
  end

  def get_xpath_value xpath
    wait_for_xpath_to_display xpath
    driver.find_element(:xpath, xpath).value
  end

  def get_xpath_label xpath
    wait_for_xpath_to_display xpath
    driver.find_element(:xpath, xpath).label
  end

  def get_name_text name
    wait_for_name_to_display name
    driver.find_element(:name, name).text
  end

  def button_displayed? buttonText
    #    button(button).displayed?
    exists { button(buttonText) }
  end

  def button_displayed_with_scroll buttonText
    if exists { button(buttonText) } == false
      scroll_to buttonText
    end
    exists { button(buttonText) }
  end


  def button_enabled? button
    #   xpath_enabled?(locator.button_xpath_for button)
    button(button).enabled?
  end

  def wait_for_button_to_display button
    common.wait_true { button_displayed? button }
  end

  def click_button button
    wait_for_button_to_display button
    button(button).click
  end

  def id_displayed? id
    begin
      driver.find_element(:id, id).displayed?
    rescue
      return false
    end
  end

  def id_displayed_uia id
    #This method is an alternative to the above - doesnt use webdriver.
    begin
      if id(id)
        true
      end
    rescue
      false
    end
  end

  def get_element_with_id id
    wait_true { driver.find_element(:id, id) }
  end

  def get_all_elements_with_id id
    wait_true { driver.find_elements(:id, id) }
  end

  def get_all_elements_with_class elementclass
    wait_true { driver.find_elements(:class, elementclass) }
  end

  def get_all_elements_with_xpath xpath
    wait_true { driver.find_elements(:xpath, xpath) }
  end

  def get_all_ids_text id
    all_driver_elements = get_all_elements_with_id id
    text_from_driver_elements = Array.new
    all_driver_elements.each { |i| text_from_driver_elements.push(i.text) }
    text_from_driver_elements
  end

  def get_all_class_elements_text elementclass
    all_driver_elements = get_all_elements_with_class elementclass
    text_from_driver_elements = Array.new
    all_driver_elements.each { |i| text_from_driver_elements.push(i.text) }
    text_from_driver_elements
  end
  def wait_for_id_to_display id
    wait_true { id_displayed? id }
  end

  def click_id id
    wait_for_id_to_display id
    driver.find_element(:id, id).click
  end

  def click_name name
    wait_for_name_to_display name
    driver.find_element(:name, name).click
  end

  def long_click_id id
    wait_for_id_to_display id
    element=driver.find_element(:id, id)
    driver.execute_script "mobile: longClick", :element => element.ref
  end

  def get_id_text id
    wait_for_id_to_display id
    driver.find_element(:id, id).text
  end

  def text_or_content_desc_present? text_or_content_desc
    begin
      driver.find_element(:name, text_or_content_desc).displayed?
    rescue
      return false
    end
  end

  def wait_for_text_or_content_desc text_or_content_desc
    wait_true { text_or_content_desc_present? text_or_content_desc }
  end

  def click_text_or_content_desc text_or_content_desc
    wait_for_text_or_content_desc text_or_content_desc
    driver.find_element(:name, text_or_content_desc).click
  end

  def text_displayed? text
    #xpath_displayed?(locator.text_xpath_for text)
    begin
      if text(text).displayed?
        return true
      end
    rescue
      return false
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

  def fill_in_id id, text
    wait_for_id_to_display id
    element = driver.find_element(:id, id)
    element.clear
    element.send_keys text
  end

  def fill_in_xpath xpath, text
    wait_for_xpath_to_display xpath
    sleep 1 # let's be sure it's ready to be used
    element = driver.find_element(:xpath, xpath)
    element.clear
    #element.clear
    #element.clear
    sleep 1
    element.send_keys text
  end

  def fill_in_name name, text
    wait_for_name_to_display name
    sleep 1 # let's be sure it's ready to be used
    element = driver.find_element(:name, name)
    element.clear
    element.clear
    element.clear
    element.send_keys text
  end

  def id_selected? id
    wait_for_id_to_display id
    element = driver.find_element(:id, id)
    element.attribute('checked')=="true"
  end

  def id_enabled? id
    wait_for_id_to_display id
    element = driver.find_element(:id, id)
    element.attribute('enabled')=="true"
  end

  def get_contentdesc_of_id id
    driver.find_element(:id, id).attribute 'name'
  end

  def get_id_of_element element
    element.attribute 'resourceId'
  end

  def xpath_selected? xpath
    wait_for_xpath_to_display xpath
    element = driver.find_element(:xpath, xpath)
    element.attribute('value')==1
  end

  def scroll_down
    #driver.execute_script('mobile: swipe', :startY => 0.9, :endY => 0.1)
    swipe(:start_y => 0.9,:end_y => 0.5,:start_x => 0.9, :end_x => 0.9, :duration => 800)  end

  def scroll_up
    #driver.execute_script('mobile: swipe', :startY => 0.1, :endY => 0.9)
    swipe(:start_y => 0.3,:end_y => 0.9,:start_x => 0.9, :end_x => 0.9, :duration => 800)  end

  def scroll_right
    swipe(:start_x => 0.3,:end_x => 0.9,:start_y => 0.5, :end_y => 0.5, :duration => 800)
    sleep 3
  end

=begin
  #this is a wip, problems with comparing web driver elements with !=
  def get_all_ids_with_scroll id
    initial = get_all_elements_with_id id
    scroll_down
    scrolled = get_all_elements_with_id id
    while scrolled.last != initial.last
      initial = initial | scrolled
      scroll_down
      scrolled = get_all_elements_with_id id
      initial = initial | scrolled
    end
    initial
  end
=end

  def get_all_ids_text_with_scroll id
    initial = get_all_ids_text(id)
    scroll_down
    scrolled = get_all_ids_text(id)
    while scrolled.last != initial.last
      initial = initial | scrolled
      scroll_down
      scrolled = get_all_ids_text(id)
    end
    initial
  end

  def get_all_class_elements_text_with_scroll elementclass
    initial = get_all_class_elements_text(elementclass)
    scroll_down
    scrolled = get_all_class_elements_text(elementclass)
    while scrolled.last != initial.last
      initial = initial | scrolled
      scroll_down
      scrolled = get_all_class_elements_text(elementclass)
    end
    initial
  end
  def press_device_enter_button
    press_keycode 66
  end

  def press_device_back_button
    press_keycode 4
  end

  def press_backspace
    press_keycode 67
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


end