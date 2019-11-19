RSpec.describe Rbvore::Location do
  it "fetches the location details from the API" do
    set_api_response(200, "get_location.json")
    location = Rbvore::Location.get(id: "ckga7qLi")
    expect(location).to have_attributes(
      id: "ckga7qLi",
      name: "Virtual POS",
    )
  end
end
