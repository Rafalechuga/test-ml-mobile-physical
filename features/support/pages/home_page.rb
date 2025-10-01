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
    sleep(5)
  end

  def select_nuevo_filter()
    time=1

    click_element(HomeLocators::MAIN_FILTER_SELECTOR, "Filtro principal")
    sleep(5)
    #(104,1350) Coordenadas sección CONDICION
    tap_coordinates(104,1350)
    sleep(time)
    #(425,1300) Coordenadas filtro nuevo
    tap_coordinates(425,896)
    sleep(time)

    #(100,817) Hacer clic de nuevo en la sección CONDICIÖN para eliminar error de despliegue
    tap_coordinates(100,817)
    sleep(time)

    #(750,2133) Coordenadas boton Ver {N} resultados
    tap_coordinates(750,2133)
    sleep(time)

  end

  def select_cp_filter(cp)
    time = 1

    click_element(HomeLocators::CP_FILTER_SELECTOR, "Boton ingresa tu codigo postal")
    sleep(time)

    fill_bar(HomeLocators::CP_BAR_SELECTOR, "Barra de busqueda de codigo potal", cp)
    sleep(10)

    click_element(HomeLocators::GO_BACK_BUTTON_AFTER_CP_SELECTOR, "Boton go back despues de ingresar tu codigo postal")
    sleep(time)

  end

  def select_expensive_filter()
    time=1

    click_element(HomeLocators::MAIN_FILTER_SELECTOR, "Filtro principal")
    sleep(5)

    # (129,1950) -> (129,791) 
    #long_press_and_scroll(129,1950, 129,791)
    swipe(129,1950, 129,791)
    swipe(129,1950, 129,791)
    sleep(time)


    #(129,1990) Coordenadas sección ORDENAR POR
    tap_coordinates(129,1990)
    sleep(time)

    #(480,1840) Coordenadas filtro Mayor precio
    tap_coordinates(800,1840)
    sleep(time)

    #(750,2133) Coordenadas boton Ver {N} resultados
    tap_coordinates(750,2133)
    sleep(time)

  end 

end
