Feature: Historical reports
  As the financial officer of a small record label
  I want to generate financial reports 
  So that artists can be kept up to date and payments calculated

  Scenario: First report, not yet broken even
    Given the only artist on my books is DJ Doo Doo   
    And his real name is Tarquin Whiteboy
    And his only release, 'Wubz 4 Eva' was published four months ago
    And it cost $100 for mastering
    And it cost $50 for cover art
    And it cost $20 for digital distribution
    And it cost $200 for promotion
    And we have agreed to split revenue evenly after costs   
    And this is the first time I am doing a report
    And it has taken $300 in sales
    And I have all this info in spreadsheets
    When I generate the report
    Then it should greet him by name
    And it should show that he is entitled to nothing
    And it should show that $70 is still to go before we break even
