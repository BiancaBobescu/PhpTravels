Feature: Php Travels

  Background:
    Given user navigates to homepage
    Given user searches following flights
      | from | to  | departureIn | adults | children |
      | JFK  | MUC | 14          | 2      | 2        |

  Scenario: Result flights are sorted ascending by price
    Then the displayed results should be sorted by price ascending

  Scenario: All result flights have NYC as departure point and MUC as destination
    Then the displayed results should have "NYC" as departure point and "MUC" as destination

  #Scenario: User chooses the shortest route and books it
   # Given the user chooses the shortest route and proceeds with booking
    #Given the user enters  credentials
    #Given user fills the forms and accepts terms and conditions
    #When user submits form
    #Then he should receive the bill