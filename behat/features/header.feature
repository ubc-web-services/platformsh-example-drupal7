@header
@api
Feature: Check header region

  Scenario: Should be redirected to homepage when unit name is clicked
    Given I am on "/"
    #And I am logged in as an "Administrator"
    And I visit "/"
    Then I should be on "/"
