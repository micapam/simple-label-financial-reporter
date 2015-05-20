Feature: Historical reports
  As the financial officer of a small record label
  I want to generate financial reports 
  So that artists can be kept up to date and payments calculated

  Scenario: First report, not yet broken even
    Given the only artist on my books is DJ Doo Doo   
    And his real name is Tarquin Whiteboy
    And his only release, 'Wubz 4 Eva' was published six months ago
    And it cost $200 in total to produce
    And we have agreed to split revenue evenly after profits    
    And this is the first time I am doing a report
    And the release has made $50
    And I have all this info in spreadsheets
    When I generate the report
    Then it should greet him as Dear Mr Whiteboy
    And it should show that he is entitled to nothing
