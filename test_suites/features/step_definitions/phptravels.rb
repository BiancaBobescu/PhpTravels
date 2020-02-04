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
  calendar = @browser.input(id: "FlightsDateStart")
  calendar.fire_event("focus")
  calendar.fire_event("mouseup")

end