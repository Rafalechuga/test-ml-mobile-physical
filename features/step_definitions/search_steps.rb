# features/step_definitions/search_steps.rb
require_relative '../support/pages/home_page'
require_relative '../support/pages/search_page'

Given('I am on the Mercado Libre home screen') do
  @home_page = HomePage.new($driver)
  @home_page.verify_home_screen
end

When('I tap on the search bar') do
  @home_page.tap_search_bar
end

When('I enter {string} in the search field') do |search_term|
  @search_page = SearchPage.new($driver)
  @search_page.enter_search_term(search_term)
end

When('I tap the search button') do
  @search_page.tap_search_button
end

Then('I should see search results for {string}') do |expected_term|
  @search_page.verify_search_results(expected_term)
end