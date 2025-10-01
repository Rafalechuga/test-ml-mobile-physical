# features/support/env.rb
require 'appium_lib'
require 'cucumber'
require 'rspec'
require 'rspec/expectations'

# Cargar todos los archivos de pages y locators
Dir[File.join(File.dirname(__FILE__), 'pages', '*.rb')].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), '..', 'locators', '*.rb')].each { |file| require file }

# Configuración de RSpec
World(RSpec::Matchers)

def caps
  {
    platformName: 'Android',
    platformVersion: '15',
    deviceName: 'SM_A155M',
    automationName: 'UiAutomator2',
    appPackage: 'com.mercadolibre',
    appActivity: '.splash.SplashActivity',  # ¡ACTIVIDAD CORRECTA!
    noReset: false,
    fullReset: false,
    autoGrantPermissions: true,
    newCommandTimeout: 60,
    udid: 'RF8X10AAL8X',
    systemPort: 8200,
    uiautomator2ServerLaunchTimeout: 60000,
    # Configuraciones adicionales para mejor rendimiento
    disableWindowAnimation: true,
    skipUnlock: true,
    ignoreHiddenApiPolicyError: true,
    enforceAppInstall: false
  }
end

# Inicializar driver
$driver = Appium::Driver.new({ caps: caps, appium_lib: { wait: 30 } }, true)
Appium.promote_appium_methods Object

Before do
  puts "Iniciando Mercado Libre en Samsung A15..."
  puts "AppPackage: com.mercadolibre"
  puts "AppActivity: .splash.SplashActivity"
  
  $driver.start_driver
  
  # Esperar que la app cargue completamente (Splash screen puede tomar tiempo)
  sleep 10
  puts "App iniciada correctamente, comenzando pruebas..."
end

After do |scenario|
  if scenario.failed?
    timestamp = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
    screenshot_file = "screenshot_#{timestamp}.png"
    begin
      $driver.screenshot(screenshot_file)
      embed(screenshot_file, 'image/png')
      puts "Screenshot capturada: #{screenshot_file}"
    rescue => e
      puts "No se pudo capturar screenshot: #{e.message}"
    end
  end
  
  if $driver
    begin
      $driver.driver_quit
      puts "Driver cerrado correctamente"
    rescue => e
      puts "Error cerrando driver: #{e.message}"
    end
  end
end