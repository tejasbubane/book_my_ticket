# Custom RSpec matcher for checking if event exists on a page

RSpec::Matchers.define :have_event do |event, tag: "li"|
  match do |page|
    page.has_selector?("#{tag}[data-uuid='#{event.id}']")
  end

  failure_message do |page|
    "expected #{page} to have event with ID #{event.id}"
  end

  failure_message_when_negated do |actual|
    "expected #{page} not to have event with ID #{event.id}"
  end
end
