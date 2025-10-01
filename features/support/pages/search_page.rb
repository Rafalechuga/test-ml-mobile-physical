# features/support/pages/search_page.rb
require_relative 'base_page'
require_relative '../../locators/search_locators'

class SearchPage < BasePage
  include SearchLocators

  def initialize(driver)
    super(driver)
  end

  def enter_search_term(term)
    puts "Escribiendo: #{term}"
    
    input_element = find_element_with_retry(INPUT_SELECTORS, "Campo de búsqueda")
    expect(input_element).not_to be_nil, "No se pudo encontrar el campo de búsqueda"
    
    input_element.clear
    input_element.send_keys(term)
    puts "Texto ingresado: #{term}"
    input_element
  end

  def tap_search_button
    puts "Ejecutando búsqueda..."
    
    search_button = find_element_with_retry(BUTTON_SELECTORS, "Botón de búsqueda")
    
    if search_button
      search_button.click
    else
      # Fallback: presionar Enter
      puts "Usando ENTER como fallback"
      @driver.press_keycode(66) # KEYCODE_ENTER
    end
    
    puts "Búsqueda ejecutada"
  end

  def verify_search_results(expected_term)
    puts "Verificando resultados para: #{expected_term}"
    
    # Esperar que carguen los resultados
    sleep(7)
    
    results_found = false
    results_info = ""
    
    # Verificar múltiples tipos de resultados
    RESULTS_SELECTORS.each do |key, selector|
      begin
        if key == :product_items || key == :product_cards
          elements = @driver.find_elements(selector.keys.first, selector.values.first)
          if elements.any?
            results_found = true
            results_info += "#{elements.size} #{key} encontrados. "
          end
        else
          element = @driver.find_element(selector.keys.first, selector.values.first)
          results_found = true
          results_info += "#{key} visible. "
        end
      rescue => e
        puts "No se encontró: #{key}"
      end
    end
    
    expect(results_found).to be_truthy, 
      "No se encontraron resultados de búsqueda. Elementos buscados: #{RESULTS_SELECTORS.keys.join(', ')}"
    
    puts "¡PRUEBA EXITOSA!"
    puts "Búsqueda completada: #{expected_term}"
    puts "#{results_info}"
  end

  private

  def expect(condition)
    raise "Assertion failed" unless condition
  end
end
