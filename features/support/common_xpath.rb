module CommonModule
  module Xpath

    def xpath_exists?(xpath)
      get_all_elements({ xpath: xpath }).count>0
    end

    def xpath_enabled?(xpath)
      get_element({ xpath: xpath }).enabled?
    end

    def xpath_present?(xpath)
      get_element({ xpath: xpath }).present?
    rescue false
    end

    def xpath_selected?(xpath)
      element = get_element({ xpath: xpath })
      element.attribute('value')==1
    end

  end
end