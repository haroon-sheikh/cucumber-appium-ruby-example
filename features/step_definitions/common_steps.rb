# TODO: Probably delete these if you won't need them, just left them in as examples

Given(/^the user has opened the app and the app's main page is displayed$/) do
  screen.wait_for_home
end

Then(/^the user sees the text "(.*?)"$/) do |content|
  common.wait_for_text_to_display content
end

When(/^the user selects "([^"]*)" or "([^"]*)"$/) do |buttonText1,buttonText2|
  if common.button_displayed?(buttonText1)
    button(buttonText1).click
  else
    button(buttonText2).click
  end
end

When(/^the user selects the device Back option$/) do
  common.press_device_back_button
end


When (/^the user swipes right$/) do
  common.scroll_right
end