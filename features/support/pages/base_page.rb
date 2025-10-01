# Clase que guarda metodos generales para interactuar con la aplicación
# 
class BasePage


  # Método constructor de la clase BasePage
  #
  # @param driver [Appium::Driver] Referencia a un objeto driver
  def initialize(driver)
    @driver = driver
  end

  def find_element_with_retry(selectors, element_name = "elemento")
    element = nil
    selectors.each do |selector|
      begin
        element = @driver.find_element(selector.keys.first, selector.values.first)
        if element && (element.displayed? || element.enabled?)
          puts "#{element_name} encontrado con: #{selector}"
          return element
        end
      rescue => e
        puts "Selector falló: #{selector}"
      end
    end
    nil
  end

  def find_element_by_id_with_retry(ids, element_name = "elemento")
    element = nil
    ids.each do |id|
      begin
        element = @driver.find_element(:id, id)
        if element
          puts "#{element_name} encontrado: #{id}"
          return element
        end
      rescue => e
        puts "No se encontró: #{id}"
      end
    end
    nil
  end

  def wait_for_element(timeout: 30)
    Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  def sleep(seconds)
    Kernel.sleep(seconds)
  end

  def click_element(locator, description)
    clickable_element = find_element_with_retry(locator, description)
    expect(clickable_element).not_to be_nil, "No se pudo encontrar el campo de búsqueda: " + description
    tap_element.click
  end

  private

  def expect(condition)
    raise "Assertion failed" unless condition
  end
end
