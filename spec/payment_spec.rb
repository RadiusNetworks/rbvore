# frozen_string_literal: true

RSpec.describe Rbvore::Payment do
  it "fetches all the payments for a ticket" do
    set_api_response(200, "get_payments.json")
    payments = Rbvore::Payment.fetch_all(location_id: "ckga7qLi", ticket_id: "2")
    expect(payments.first).to be_a Rbvore::Payment
    expect(payments.first).to have_attributes(
      amount: 699,
      change: 0,
      tip: 200,
      tender_type: be_a(Rbvore::TenderType),
    )
  end
end
