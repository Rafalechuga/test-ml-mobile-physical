# features/support/pages/home_page.rb
require_relative 'base_page'
require_relative '../../locators/home_locators'

class HomePage < BasePage
  include HomeLocators

  def initialize(driver)
    super(driver)
  end

  def verify_home_screen
    puts "Buscando pantalla principal de Mercado Libre..."
    
    home_element = find_element_by_id_with_retry(HOME_INDICATORS, "Elemento de home")
    expect(home_element).not_to be_nil, "No se pudo identificar la pantalla principal de Mercado Libre"
    
    puts "Pantalla principal identificada correctamente"
    home_element
  end

  def tap_search_bar
    puts "Tocando barra de búsqueda..."
    
    search_element = find_element_with_retry(SEARCH_BAR_SELECTORS, "Barra de búsqueda")
    expect(search_element).not_to be_nil, "No se pudo encontrar la barra de búsqueda"
    
    search_element.click
    sleep(3) # Esperar que se abra el teclado
    search_element
  end

  private

  def expect(condition)
    raise "Assertion failed" unless condition
  end
end
