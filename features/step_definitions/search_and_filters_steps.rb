# features/step_definitions/search_steps.rb
require_relative '../support/pages/login_page'
require_relative '../support/pages/home_page'

Given('I am on the Mercado Libre login page') do
  @login_page = LoginPage.new($driver)
  @home_page = HomePage.new($driver)
end

When('I tap on the ContinuarComoInvitado button') do
  @login_page.tap_continuar_como_visitante
end

When('I tap on the main search bar') do
  @home_page.tap_search_bar()
end

When('I enter {string} in the search bar') do |term|
  @home_page.search(term)
end
