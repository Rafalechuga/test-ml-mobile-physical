# features/step_definitions/search_steps.rb
require_relative '../support/pages/login_page'

Given('I am on the Mercado Libre login page') do
  @login_page = LoginPage.new($driver)
end

When('I tap on the ContinuarComoInvitado button') do
  @login_page.tap_continuar_como_visitante
end
