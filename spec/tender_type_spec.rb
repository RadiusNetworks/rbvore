# frozen_string_literal: true

RSpec.describe Rbvore::TenderType do
  it "fetches all the tender types for a location" do
    set_api_response(200, "get_tender_types.json")
    tender_types = Rbvore::TenderType.fetch_all(location_id: "ckga7qLi")
    expect(tender_types.first).to be_a Rbvore::TenderType
    expect(tender_types.first).to have_attributes(
      allows_tips: true,
      id: "100",
      name: "3rd Party",
      pos_id: "100",
    )
  end
end
