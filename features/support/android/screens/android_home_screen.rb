module AndroidScreens

  # TODO: Probably delete these if you won't need them, just left them in as examples
  SEARCH_BOX_TEXT = { id: 'txt_search_auto_complete' }

  def list_of_story_contents?
    common.element_displayed? SEARCH_BOX_TEXT
  end

end