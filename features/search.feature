Feature: Mercado Libre Search on Physical Device
  As a user with a Samsung A15
  I want to search for products in Mercado Libre
  So that I can find what I'm looking for quickly

  Scenario: Search for iPhone in Mercado Libre on real device
    Given I am on the Mercado Libre home screen
    When I tap on the search bar
    And I enter "iPhone 15" in the search field
    And I tap the search button
    Then I should see search results for "iPhone 15"

  Scenario: Search for laptop in Mercado Libre on real device
    Given I am on the Mercado Libre home screen
    When I tap on the search bar
    And I enter "laptop gamer" in the search field
    And I tap the search button
    Then I should see search results for "laptop gamer"
    
