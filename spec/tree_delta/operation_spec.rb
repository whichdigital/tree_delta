require "spec_helper"

RSpec.describe TreeDelta::Operation do

  describe "equality" do
    it "returns true if the operations' attributes are equal" do
      expect(
        described_class.new(type: :delete, id: "foo")
      ).to eq(
        described_class.new(type: :delete, id: "foo")
      )
    end

    it "returns false otherwise" do
      expect(
        described_class.new(type: :delete, id: "foo")
      ).to_not eq(
        described_class.new(type: :delete, id: "bar")
      )
    end
  end

end
