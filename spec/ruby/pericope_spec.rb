# frozen_string_literal: true

RSpec.describe Ruby::Pericope do
  it "has a version number" do
    expect(Ruby::Pericope::VERSION).not_to be_nil
  end

  it "exposes a version string" do
    expect(Ruby::Pericope::VERSION).to be_a(String)
  end
end
