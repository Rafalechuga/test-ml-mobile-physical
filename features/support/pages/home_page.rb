# features/support/pages/home_page.rb
require_relative 'base_page'
require_relative '../../locators/home_locators'

class HomePage < BasePage
  include HomeLocators

  def initialize(driver)
    super(driver)
  end

  def tap_search_bar()
    click_element(HomeLocators::SEARCH_BAR_SELECTORS, "Barra de busqueda")
    sleep(3)
  end

  def search(term)
    fill_bar(HomeLocators::SEARCH_BAR_DEPLOYED_SELECTORS, "Barra de busqueda desplegada", term)
    sleep(20)
  end

end
