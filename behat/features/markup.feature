@markup
@api
Feature: Check for regions

  Scenario: admin should have access to "/admin"
    Given I am on "/"
    And I am logged in as an "Administrator"
    And I visit "/admin"
    Then the response status code should be 200

  Scenario Outline: check for buttons
    Given I am on "/"
    Then I find <button>

    Examples:
      |    button    |
      | "UBC Search" |

  Scenario Outline: check for links
    Given I am on "/"
    When I follow <link> in the <region>
    Then I must be on <destination>

    Examples:
      |                 link                 |   region   |      destination     |
      | "The University of British Columbia" | "wordmark" | "https://www.ubc.ca" |
      | "The University of British Columbia" |   "logo"   | "https://www.ubc.ca" |
      | "The University of British Columbia" |  "footer"  | "https://www.ubc.ca" |

  Scenario Outline: check for elements
    Given I am on "/"
    Then I should see the <element> element in the <region>

    Examples:
      |            element               |  region  |
      |      "#ubc7-global-menu"         |  "body"  |
      |         "#ubc7-search"           |  "body"  |
      |       "#ubc7-search-box"         |  "body"  |
      |      "#ubc7-global-header"       |  "body"  |
      |       "#ubc7-unit-name"          |  "body"  |
      |        "#ubc7-unit-menu"         |  "body"  |
      |     "#ubc7-unit-navigation"      |  "body"  |
      | "#ubc7-unit-alternate-navigation"|  "body"  |
      |     "#ubc7-unit-identifier"      |  "unit"  |
      |      "#ubc7-unit-footer"         | "footer" |
      |      ".ubc7-back-to-top"         | "footer" |
      |      "#ubc7-global-footer"       | "footer" |
      |        "#ubc7-signature"         | "footer" |
      |       "#ubc7-footer-menu"        | "footer" |
      |      "#ubc7-minimal-footer"      | "footer" |
