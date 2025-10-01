# features/support/pages/base_page.rb
class BasePage
  def initialize(driver)
    @driver = driver
  end

  def find_element_with_retry(selectors, element_name = "elemento", timeout: 10)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout)
    
    selectors.each do |selector|
      begin
        element = wait.until { @driver.find_element(selector.keys.first, selector.values.first) }
        if element && (element.displayed? || element.enabled?)
          puts "#{element_name} encontrado con: #{selector}"
          return element
        end
      rescue => e
        puts "Selector falló: #{selector} - #{e.message}"
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

  def fill_bar(locator, description, term)
    element = find_element_with_retry(locator, description)
    if element.nil?
      raise "No se pudo encontrar el elemento: #{description}"
    end
    element.click
    sleep(5)
    
    element.clear
    element.send_keys(term)
    @driver.press_keycode(66) # KEYCODE_ENTER
  end

  def wait_for_element(timeout: 30)
    Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  def sleep(seconds)
    Kernel.sleep(seconds)
  end
end
