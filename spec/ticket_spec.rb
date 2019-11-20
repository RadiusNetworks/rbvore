# frozen_string_literal: true

RSpec.describe Rbvore::Ticket do
  let(:tickets) {
    set_api_response(200, "get_tickets.json")
    Rbvore::Ticket.all(location_id: "ckga7qLi")
  }

  it "fetches a list of tickets for a location from the API" do
    expect(tickets.length).to eq 2
    expect(tickets.first).to be_a Rbvore::Ticket
    expect(tickets.first).to have_attributes(
      id: "2",
      guest_count: 1,
      open: false,
      order_type: be_a(Rbvore::OrderType),
    )
  end

  it "parses embedded collections" do
    expect(tickets.first.payments.length).to eq(4)
    expect(tickets.first.payments.first).to be_a Rbvore::Payment
    expect(tickets.first.payments.first).to have_attributes(
      id: "166471",
      amount: 699,
      tip: 200,
    )
  end
end
