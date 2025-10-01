# features/locators/search_locators.rb
module SearchLocators
  INPUT_SELECTORS = [
    { id: 'com.mercadolibre:id/search_input' },
    { class: 'android.widget.EditText' },
    { xpath: '//android.widget.EditText' }
  ].freeze

  BUTTON_SELECTORS = [
    { id: 'com.mercadolibre:id/search_execute' },
    { accessibility_id: 'Buscar' },
    { xpath: '//android.widget.Button[contains(@text, "Buscar")]' },
    { xpath: '//android.widget.ImageButton[@content-desc="Buscar"]' }
  ].freeze

  RESULTS_SELECTORS = {
    results_list: { id: 'com.mercadolibre:id/results_list' },
    product_items: { id: 'com.mercadolibre:id/item_container' },
    results_title: { id: 'com.mercadolibre:id/search_results_title' },
    product_cards: { xpath: '//android.view.ViewGroup[contains(@resource-id, "item")]' }
  }.freeze
end
