# Modulo para guardar los localizadores de la pagina para iniciar sesión
# 
module LoginPageLocators

  BUTTON_CONTINUAR_COMO_VISITANTE = [
    { xpath: '//android.widget.Button[contains(@text, "Buscar")]' },
    { id: 'com.mercadolibre:id/andes_button_text' },
    { xpath: '//android.widget.Button[contains(@text, "Continuar como visitante")]' },
    { xpath: '//android.widget.Button[contains(@text, "Continuar")]' },
    { xpath: '//android.widget.Button[contains(@text, "como")]' },
    { xpath: '//android.widget.Button[contains(@text, "visitante")]' },
    { xpath: '//android.widget.Button' }
  ].freeze

end