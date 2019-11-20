# frozen_string_literal: true

RSpec.describe Rbvore do
  it "has a version number" do
    expect(Rbvore::VERSION).not_to be nil
  end

  it "can turn a resource class name into a constant" do
    expect(Rbvore.constantize("ticket")).to be Rbvore::Ticket
  end
end
