# features/locators/home_locators.rb
module HomeLocators

  #DEBUGUED
  SEARCH_BAR_SELECTORS = [
    { id: 'com.mercadolibre:id/ui_components_toolbar_search_field' },
    { xpath: '//android.widget.LinearLayout[@resource-id="com.mercadolibre:id/ui_components_toolbar_search_field"]' },
    { xpath: '//android.widget.TextView[contains(@text, "Buscar en Mercado Libre")]' },
    { xpath: '//android.widget.TextView[contains(@text, "Buscar")]' },
    { accessibility_id: 'search_bar' }

  ].freeze

  #DEBUGUED
  SEARCH_BAR_DEPLOYED_SELECTORS = [
    { xpath: '//android.widget.EditText[@resource-id="com.mercadolibre:id/autosuggest_input_search"]' },
    { xpath: '//android.widget.TextView[contains(@text, "Buscar")]' },
    { class: 'android.widget.EditText' }

  ].freeze

  #DEBUGUED
  MAIN_FILTER_SELECTOR = [
    { xpath: '(//android.widget.LinearLayout[@resource-id="com.mercadolibre:id/appbar_content_layout"])[1]/android.widget.LinearLayout' },
    { xpath: '//android.widget.TextView[@text="Filtros"]' },
    { xpath: '//android.widget.TextView[contains(@text, "Filtros")]' },
    { class: 'android.widget.TextView' }

  ].freeze


  #DEBUGUED
  CP_FILTER_SELECTOR = [
    { id: 'com.mercadolibre:id/destination' },
    { xpath: '//android.widget.TextView[@content-desc="Ubicación, Ingresa tu código postal"]' },
    { xpath: '//android.widget.TextView[@text="Ubicación, Ingresa tu código postal"]' },
    { xpath: '//android.widget.TextView[contains(@text, "postal")]' },
    { id: 'com.mercadolibre:id/navigationcp_bar_chevron' }

  ].freeze


  CP_BAR_SELECTOR = [
    { xpath: '//android.widget.EditText' },
    { class: 'android.widget.EditText' }

  ].freeze

  CP_USAR_BUTTON_SELECTOR = [
    { id: 'com.mercadolibre:id/action_button' },
    { xpath: '//android.widget.Button[contains(@text, "Usar")]' },
    { xpath: '//android.widget.Button[contains(@text, "Aplicar")]' },
    { xpath: '//android.widget.Button[contains(@text, "OK")]' },
    { xpath: '//android.widget.Button' }

  ].freeze

  GO_BACK_BUTTON_AFTER_CP_SELECTOR = [
    { xpath: '//android.widget.ImageButton[@content-desc="Atras"]' },
    { class: 'android.widget.ImageButton' }

  ].freeze


end
