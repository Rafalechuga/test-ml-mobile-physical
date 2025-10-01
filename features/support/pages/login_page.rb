# features/support/pages/search_page.rb
require_relative 'base_page'
require_relative '../../locators/login_page_locators'

class LoginPage < BasePage
  include LoginPageLocators

  def initialize(driver)
    super(driver)
  end

  def tap_continuar_como_visitante()
    click_element(BUTTON_CONTINUAR_COMO_VISITANTE, "Continuar como visitante")
  end

end