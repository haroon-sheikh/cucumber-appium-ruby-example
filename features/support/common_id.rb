module CommonModule
  module Id

    def id_displayed_uia(id)
      #This method is an alternative, doesnt use webdriver.
      begin
        true if id(id)
      rescue
        false
      end
    end

    def long_click_id(id)
      element = get_element({ id: id })
      driver.execute_script "mobile: longClick", :element => element.ref
    end

    def id_selected?(id)
      element = get_element({ id: id })
      element.attribute('checked')=="true"
    end

    def id_enabled?(id)
      element = get_element({ id: id })
      element.attribute('enabled')=="true"
    end

    def get_contentdesc_of_id(id)
      get_element({ id: id }).attribute 'name'
    end

    def get_id_of_element(element)
      element.attribute 'resourceId'
    end

  end
end