# frozen_string_literal: true

RSpec.describe Pericope do
  it "has a version number" do
    expect(Pericope::VERSION).not_to be_nil
  end

  it "exposes a version string" do
    expect(Pericope::VERSION).to be_a(String)
  end
end
