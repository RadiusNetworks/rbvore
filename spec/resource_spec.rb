# frozen_string_literal: true

RSpec.describe Rbvore::Resource do
  it "can generate an endpoint for a given resource type" do
    expect(Rbvore::Location.endpoint).to eq "/1.0/locations"
    expect(Rbvore::Location.endpoint(id: "123")).to eq "/1.0/locations/123"
    expect { Rbvore::Table.endpoint }.to raise_error Rbvore::Error
    expect(Rbvore::Table.endpoint(location_id: "123")).to eq "/1.0/locations/123/tables"
    expect(Rbvore::TenderType.endpoint(location_id: "123")).to eq "/1.0/locations/123/tender_types"
    expect(Rbvore::Ticket.endpoint(location_id: "123")).to eq "/1.0/locations/123/tickets"
    expect(Rbvore::Ticket.endpoint(id: "456", location_id: "123"))
      .to eq "/1.0/locations/123/tickets/456"
    expect(Rbvore::Payment.endpoint(location_id: "123", ticket_id: "456"))
      .to eq "/1.0/locations/123/tickets/456/payments"
  end
end
