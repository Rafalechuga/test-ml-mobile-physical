# features/support/pages/home_page.rb
require_relative 'base_page'
require_relative '../../locators/home_locators'
require 'nokogiri'

class HomePage < BasePage
  include HomeLocators

  def initialize(driver)
    super(driver)
  end

  def tap_search_bar
    take_screenshot()
    click_element(HomeLocators::SEARCH_BAR_SELECTORS, "Barra de busqueda")
    sleep(3)
  end

  def search(term)
    fill_bar(HomeLocators::SEARCH_BAR_DEPLOYED_SELECTORS, "Barra de busqueda desplegada", term)
    take_screenshot()
    sleep(5)
  end

  def select_nuevo_filter
    time = 1
    click_element(HomeLocators::MAIN_FILTER_SELECTOR, "Filtro principal")
    sleep(5)
    tap_coordinates(104, 1350) # sección CONDICIÓN
    sleep(time)
    tap_coordinates(425, 896)  # filtro nuevo
    sleep(time)
    tap_coordinates(100, 817)  # clic extra para corregir despliegue
    
    take_screenshot()

    sleep(time)
    tap_coordinates(750, 2133) # Ver resultados
    sleep(time)
  end

  def select_cp_filter(cp)
    time = 1
    click_element(HomeLocators::CP_FILTER_SELECTOR, "Boton ingresa tu codigo postal")
    sleep(time)
    fill_bar(HomeLocators::CP_BAR_SELECTOR, "Barra de busqueda de codigo postal", cp)
    take_screenshot()

    sleep(10)
    click_element(HomeLocators::GO_BACK_BUTTON_AFTER_CP_SELECTOR, "Boton go back")
    sleep(time)
  end

  def select_expensive_filter
    time = 1
    click_element(HomeLocators::MAIN_FILTER_SELECTOR, "Filtro principal")
    sleep(5)
    swipe(129, 1950, 129, 791)
    swipe(129, 1950, 129, 791)
    sleep(time)
    tap_coordinates(129, 1990)  # ORDENAR POR
    sleep(time)
    tap_coordinates(800, 1840)  # Mayor precio
    take_screenshot()
    sleep(time)

    tap_coordinates(750, 2133)  # Ver resultados
    sleep(time)

    take_screenshot()
    
    get_first_five_products()
  end

  # Imprime los primeros 5 productos visibles haciendo scroll si es necesario
  def get_first_five_products
    products = []
    last_count = 0

    loop do
      xml_source = driver.page_source
      doc = Nokogiri::XML(xml_source)

      doc.xpath("//android.view.View[@resource-id='polycard_component']").each do |prod_node|
        next if products.size >= 5

        # Nombre
        name_node = prod_node.xpath(".//android.widget.TextView[@text and not(@resource-id)]").first
        next unless name_node
        name = name_node['text'].strip

        # Precio relativo
        price_node = prod_node.xpath(".//android.widget.TextView[@resource-id='current amount']").first
        price = price_node ? price_node['content-desc'].strip : nil

        # Solo agregar si tiene precio
        if price
          unless products.any? { |p| p[:name] == name }
            products << { name: name, price: price }
          end
        end
      end

      break if products.size >= 5

      # Si no hay nuevos productos con precio, hacer scroll
      break if last_count == products.size
      last_count = products.size

      swipe(500, 1800, 500, 500) # Ajusta según pantalla
      sleep(2)
    end

    puts "=== Primeros 5 productos ==="
    products.each_with_index do |p, i|
      puts "#{i+1}. #{p[:name]} - #{p[:price]}"
    end
  end

end

