@api
@monitoring
Feature: Monitoring Set

  @CiviCRM
  Scenario: Check if CiviCRM is set up
    Given I am on "/"
    And I am logged in as an "Administrator"
    When I am on "/civicrm/event/manage"
    Then the response status code should be 200
  @CiviCRM
  Scenario: Check if CiviCRM manage events page is not accessible to anonymous users
    Given I am on "/"
    When I am on "/civicrm/event/manage"
    Then the response status code should be 403

  @Shibboleth
  Scenario: Should invoke Shibboleth login AND redirected to the CWL login page
    Given I am on "/Shibboleth.sso/Login?entityID=https://shibboleth2.id.ubc.ca/idp/shibboleth"
    Then the response status code should be 200
    Then I must be on "https://shibboleth2.id.ubc.ca/idp/Authn/UserPassword"
  @Shibboleth
  Scenario: Successful login scenario
    Given I am on "/Shibboleth.sso/Login?entityID=https://shibboleth2.id.ubc.ca/idp/shibboleth"
    Then I must be on "https://shibboleth2.id.ubc.ca/idp/Authn/UserPassword"
    When I fill in "j_username" with "username"
    When I fill in "j_password" with "password"
    When I press "Continue"
    Then I should be on "/"
  @Shibboleth
  Scenario: Unsuccessful login scenario
    Given I am on "/Shibboleth.sso/Login?entityID=https://shibboleth2.id.ubc.ca/idp/shibboleth"
    #Then the response status code should be 200
    Then I must be on "https://shibboleth2.id.ubc.ca/idp/Authn/UserPassword"
    When I fill in "j_username" with "username"
    When I fill in "j_password" with "pdarowss"
    When I press "Continue"
    Then I must not be on "/"

  @Healthcheck
	Scenario: Internal path /healthcheck/scom should exist and accessible
		Given I am on "/healthcheck/scom"
		Then the response status code should be 200
  @Healthcheck
	Scenario: Internal path /healthcheck/scom should exist and accessible
		Given I am on "/healthcheck/host"
		Then the response status code should be 200
		Then I should not see "Hosted at UBC" in the "h3" element in the "body"
