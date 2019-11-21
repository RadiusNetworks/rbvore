# frozen_string_literal: true

RSpec.describe Rbvore::Table do
  let(:tables) {
    set_api_response(200, "get_tables.json")
    Rbvore::Table.fetch_all(location_id: "ckga7qLi")
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

  it "fetches a table with an id" do
    set_api_response(200, "get_table.json")
    table = Rbvore::Table.fetch_one(id: "2", location_id: "ckga7qLi")
    expect(table).to be_a Rbvore::Table
    expect(table).to have_attributes(
      id: "2",
      name: "2",
      number: 2,
      pos_id: "2",
      seats: 4,
    )
  end
end
