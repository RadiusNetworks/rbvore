# frozen_string_literal: true

RSpec.describe Rbvore::Location do
  it "fetches the location details from the API" do
    set_api_response(200, "get_location.json")
    location = Rbvore::Location.get(id: "ckga7qLi")
    expect(location).to have_attributes(
      id: "ckga7qLi",
      name: "Virtual POS",
    )
    expect(location.links[:self]).to be_a Rbvore::Link
    expect(location.links[:self].href).to eq "https://api.omnivore.io/1.0/locations/ckga7qLi/"
  end
end
