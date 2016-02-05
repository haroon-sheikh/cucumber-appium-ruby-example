Feature:
	As a Mobile User, I want to be able to launch the app.

	Background:
		Given the user has opened the app and the app's main page is displayed

	@android
	Scenario: User can see the home screen
		Given the user can see a list of stories
		When I click on a story
		Then I should be able to see contents of story