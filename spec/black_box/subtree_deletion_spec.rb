require "spec_helper"

describe TreeDelta do
  subject { described_class.new(from: from, to: to) }

  let(:from) do
    n("a",
      n("b",
        n("c"),
        n("d"),
        n("e")
       )
     )
  end

  let(:to) do
    n("a")
  end

  it "does not issue additional deletes for nodes in the subtree" do
    expect(subject.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id:   "b"
      ),
    ]
  end

end
