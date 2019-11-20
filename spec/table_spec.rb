# frozen_string_literal: true

RSpec.describe Rbvore::Table do
  let(:tables) {
    set_api_response(200, "get_tables.json")
    Rbvore::Table.all(location_id: "ckga7qLi")
  }

  it "fetches a list of tables for a location from the API" do
    expect(tables.length).to eq 3
    expect(tables.first).to be_a Rbvore::Table
  end

  it "parses embedded objects" do
    expect(tables.first.revenue_center).to be_a Rbvore::RevenueCenter
    expect(tables.first.revenue_center).to have_attributes(
      id: "1",
      name: "Test",
      pos_id: "1",
      default: true,
    )
  end
end
