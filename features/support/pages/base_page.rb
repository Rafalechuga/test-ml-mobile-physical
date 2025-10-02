# features/support/pages/base_page.rb
class BasePage
  def initialize(driver)
    @driver = driver
  end

  def find_element_with_retry(selectors, element_name = "elemento", timeout: 10, retry_count: 3)
    retries = 0
    
    while retries < retry_count
      begin
        wait = Selenium::WebDriver::Wait.new(timeout: timeout)
        
        selectors.each do |selector|
          begin
            element = wait.until { @driver.find_element(selector.keys.first, selector.values.first) }
            if element && (element.displayed? || element.enabled?)
              return element
            end
            rescue => e
              puts "Selector falló: #{selector} - #{e.message}"
            end
          end
        
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        retries += 1
        sleep(2)
      end
    end
    nil
  end

  def click_element(locator, description)
    element = find_element_with_retry(locator, description)
    if element.nil?
      raise "No se pudo encontrar el elemento: #{description}"
    end
    element.click
  end

  def fill_bar(locator, description, term, max_retries: 3)
    retries = 0
    
    while retries < max_retries
      begin
        element = find_element_with_retry(locator, description)
        if element.nil?
          raise "No se pudo encontrar el elemento: #{description}"
        end
        
        element.click
        sleep(3)
        
        # Limpiar y escribir con reintentos
        element.clear rescue nil # Ignorar error si no se puede limpiar
        element.send_keys(term)
        
        # Presionar ENTER
        @driver.press_keycode(66)
        
        return true
        
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        retries += 1
        sleep(2)
      rescue => e
        retries += 1
        sleep(2)
      end
  end
  
  raise "No se pudo completar fill_bar después de #{max_retries} intentos"
end


  def tap_coordinates(x, y, duration: 0)
    action = Appium::TouchAction.new
    action.tap(x: x, y: y, duration: duration)
    action.perform
    sleep 2
  end

  def long_press_and_scroll(start_x, start_y, end_x, end_y, press_duration: 1000, scroll_duration: 1000)
    action = Appium::TouchAction.new
    
    # Mantener presión inicial
    action.press(x: start_x, y: start_y, duration: press_duration)
    
    # Mover a posición final (scroll)
    action.move_to(x: end_x, y: end_y)
    action.release
    action.perform
    
    sleep 2
  end

  def swipe(start_x, start_y, end_x, end_y, duration: 1000)
    @driver.swipe(
      start_x: start_x, 
      start_y: start_y, 
      end_x: end_x, 
      end_y: end_y, 
      duration: duration
    )
    sleep 2
  end

  def take_screenshot(file_name = nil)
    Dir.mkdir('evidencia') unless Dir.exist?('evidencia')

    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    file_name ||= "screenshot_#{timestamp}.png"
    file_path = File.join('evidencia', file_name)

    # Tomar screenshot usando Appium driver
    @driver.screenshot(file_path)
    puts "Captura guardada en: #{file_path}"

    file_path
    rescue => e
      puts "Error al tomar screenshot: #{e.message}"
      nil
    end

  def wait_for_element(timeout: 30)
    Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  def sleep(seconds)
    Kernel.sleep(seconds)
  end
  
end
