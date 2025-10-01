# features/locators/home_locators.rb
module HomeLocators
  HOME_INDICATORS = [
    'com.mercadolibre:id/nav_home',
    'com.mercadolibre:id/action_search',
    'com.mercadolibre:id/search_box',
    'com.mercadolibre:id/home_container',
    'com.mercadolibre:id/bottom_navigation'
  ].freeze

  SEARCH_BAR_SELECTORS = [
    { id: 'com.mercadolibre:id/action_search' },
    { id: 'com.mercadolibre:id/search_box' },
    { xpath: '//android.widget.EditText[contains(@text, "Buscar")]' },
    { xpath: '//android.widget.TextView[contains(@text, "Buscar")]' },
    { accessibility_id: 'search_bar' }
  ].freeze
end
