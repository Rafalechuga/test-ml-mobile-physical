# features/support/pages/login_page.rb
require_relative 'base_page'
require_relative '../../locators/login_page_locators'
require_relative '../../locators/home_locators'

class LoginPage < BasePage
  include LoginPageLocators
  include HomeLocators

  def initialize(driver)
    super(driver)
  end

  def tap_continuar_como_visitante
    click_element(LoginPageLocators::BUTTON_CONTINUAR_COMO_VISITANTE, "Continuar como visitante")
    sleep(3)
  end
  
end