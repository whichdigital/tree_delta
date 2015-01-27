require "spec_helper"

describe TreeDelta do
  subject { described_class.new(from: from, to: to) }

  let(:from) do
    n("a",
      n("b"),
      n("c")
     )
  end

  let(:to) do
    n("a",
      n("c"),
      n("b")
     )
  end

  it "enumerates the correct operations" do
    expect(subject.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id:   "c"
      ),
      TreeDelta::Operation.new(
        type:    :attach,
        id:      "c",
        parent:  "a",
        position: 0
      )
    ]
  end

end
