Feature: Php Travels

  Scenario: User searches for flights and the results are sorted ascending by price

    Given user navigates to homepage
    Given user searches following flights
      | from | to  | departureIn(days) | adults | children | infants |
      | JFK  | MUC | 14                | 2      | 2        | 0       |