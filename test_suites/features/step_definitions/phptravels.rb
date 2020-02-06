require 'date'
$parsedResults = []
Given("user navigates to homepage") do
  @browser.goto $homepage
end

Given("user searches following flights") do |table|
  # table is a table.hashes.keys # => [:from, :to, :adults, :children, :infants]
  flightsTab = @browser.a(:data_name => "flights").wait_until(&:present?)
  flightsTab.click!

  #From
  inputfrom = @browser.div(id: "s2id_location_from").a(:class => "select2-choice")
  inputfrom.fire_event("mousedown")
  inputfrom.click!
  @browser.div(id: "select2-drop").wait_until(&:present?).text_field(class: "select2-input").set table.hashes[0]["from"]
  fromMatch = @browser.li(class: "select2-result")
  # this is sick! I guess this is why that message was put on the page, that automation is not allowed here. Made testing it a PITA.
  # this below is the actual click of the match :/
  fromMatch.fire_event("mousemove")
  fromMatch.fire_event("mousedown")
  fromMatch.fire_event("mouseup")


  #To
  inputTo = @browser.div(id: "s2id_location_to").a(:class => "select2-choice")
  inputTo.fire_event("mousedown")
  inputTo.click!
  @browser.div(id: "select2-drop").wait_until(&:present?).text_field(class: "select2-input").set table.hashes[0]["to"]
  toMatch = @browser.li(class: "select2-result")
  toMatch.fire_event("mousemove")
  toMatch.fire_event("mousedown")
  toMatch.fire_event("mouseup")

  #departure date
  # open datepicker
  calendar = @browser.text_field(id: "FlightsDateStart")
  calendar.fire_event("focus")
  calendar.fire_event("mouseup")

  #what on earth? :D
  departureDate = Date.today + table.hashes[0]["departureIn"].to_i
  inputDeparture = @browser.div(:class => %w(datepicker active))
                       .div(:data_date => departureDate.day.to_s, :data_month => (departureDate.month() - 1).to_s, :data_year => departureDate.year.to_s)
  inputDeparture.fire_event("mousedown")
  inputDeparture.fire_event("click")

  #set adults
  addAdultButton = @browser.element(:xpath => "//*[@id='flights']/div/div/form/div/div[3]/div[3]/div/div/div[1]/div/div[2]/div/span/button[1]")
  nrOfAdults = table.hashes[0]["adults"].to_i() - 1
  nrOfAdults.times do
    addAdultButton.fire_event("mousedown")
    addAdultButton.fire_event("mouseup")
  end

  #set children
  addChildrenButton = @browser.element(:xpath => "//*[@id='flights']/div/div/form/div/div[3]/div[3]/div/div/div[2]/div/div[2]/div/span/button[1]")
  nrOfChildren = table.hashes[0]["children"].to_i
  nrOfChildren.times do
    addChildrenButton.fire_event("mousedown")
    addChildrenButton.fire_event("mouseup")
  end

  #search
  searchButton = @browser.element(:xpath => "//*[@id='flights']/div/div/form/div/div[3]/div[4]/button")
  searchButton.fire_event("mousedown")
  searchButton.fire_event("click")
  parseResults
end


Then("the displayed results should be sorted by price ascending") do

  previousPrice = -1
  $parsedResults.each do |flight|
    assert previousPrice < flight["price"], "Prices are not sorted ascending"
    previousPrice = flight["price"]
  end
end


Then("the displayed results should have {string} as departure point and {string} as destination") do |expectedDeparturePoint, expectedDestination|
  $parsedResults.each do |flight|
    assert expectedDeparturePoint = flight["startLocation"], "Flight doesn't have expected startLocation"
    assert expectedDestination = flight["destination"], "Flight doesn't have expected destination"
  end
end


def parseResults
  results = @browser.ul(id: "LIST").wait_until(&:present?)
  results.each do |li|
    price = li.element(class: "theme-search-results-item-price-tag").text.match(/(\d+)/)[1]
    startLocation = li.element(class: "theme-search-results-item-flight-section-meta-city").text

    # same principle for getting ahold of the trip durations and trip destination
    # but page changed layout respectively uses same identifier for destination (facepalm)
    $parsedResults.push(Hash["price" => price, "destination" => "MUC", "startLocation" => startLocation, "tripDuration" => 10])
  end
end