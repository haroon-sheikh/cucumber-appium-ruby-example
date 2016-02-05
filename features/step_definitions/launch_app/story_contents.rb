Given(/^the user can see a list of stories/) do
	screen.list_of_stories_displayed?.should == true
end

When(/^I click on a story/) do
	screen.click_on_a_story
end

Then(/^I should be able to see contents of story/) do
	screen.list_of_story_contents?.should == true
end