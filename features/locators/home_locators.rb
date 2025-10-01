# features/locators/home_locators.rb
module HomeLocators

  SEARCH_BAR_SELECTORS = [
    { id: 'com.mercadolibre:id/ui_components_toolbar_search_field' },
    { xpath: '//android.widget.LinearLayout[@resource-id="com.mercadolibre:id/ui_components_toolbar_search_field"]' },
    { xpath: '//android.widget.TextView[contains(@text, "Buscar en Mercado Libre")]' },
    { xpath: '//android.widget.TextView[contains(@text, "Buscar")]' },
    { accessibility_id: 'search_bar' }

  ].freeze


  SEARCH_BAR_DEPLOYED_SELECTORS = [
    { id: 'com.mercadolibre:id/autosuggest_input_search' },
    { xpath: '//android.widget.EditText[@resource-id="com.mercadolibre:id/autosuggest_input_search"]' },
    { xpath: '//android.widget.TextView[contains(@text, "Buscar en Mercado Libre")]' },
    { xpath: '//android.widget.TextView[contains(@text, "Buscar")]' },
    { class: 'android.widget.EditText' }

  ].freeze


  MAIN_FILTER_SELECTOR = [
    { id: 'com.mercadolibre:id/autosuggest_input_search' },
    { xpath: '(//android.widget.LinearLayout[@resource-id="com.mercadolibre:id/appbar_content_layout"])[1]/android.widget.LinearLayout' },
    { xpath: '//android.widget.TextView[@text="Filtros"]' },
    { xpath: '//android.widget.TextView[contains(@text, "Filtros")]' },
    { class: 'android.widget.TextView' }

  ].freeze

end
