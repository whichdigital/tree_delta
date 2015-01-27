require "spec_helper"

describe TreeDelta::Intermediate do
  subject { described_class.new(from: from, to: to) }

  let(:from) do
    n("a",
      n("b",
        n("e"),
        n("f")
      ),
      n("d"),
      n("c"),
      n("x",
        n("y"),
        n("z")
      )
     )
  end

  let(:to) do
    n("a",
      n("x",
        n("z"),
        n("y")
      ),
      n("c"),
      n("e",
        n("b"),
        n("f")
      ),
      n("g")
    )
  end

  describe "#creates" do
    it "enumerates create operations" do
      expect(subject.creates).to be_an(Enumerator)
      expect(subject.creates.to_a).to match_array [
        TreeDelta::Operation.new(
          type:    :create,
          id:      "g",
          value:   "value",
          parent:  "a",
          position: 3
        )
      ]
    end
  end

  describe "#updates" do
    pending "TODO"
  end

  describe "#deletes" do
    it "enumerates delete operations" do
      expect(subject.deletes).to be_an(Enumerator)
      expect(subject.deletes.to_a).to match_array [
        TreeDelta::Operation.new(
          type: :delete,
          id:   "d"
        )
      ]
    end
  end

  describe "#detaches" do
    it "enumerates detach operations" do
      expect(subject.detaches).to be_an(Enumerator)
      expect(subject.detaches.to_a).to match_array [
        TreeDelta::Operation.new(
          type: :detach,
          id:   "z",
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id:   "x",
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id:   "f",
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id:   "e",
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id:   "b",
        )
      ]
    end
  end

  describe "#attaches" do
    it "enumerates attach operations" do
      expect(subject.attaches).to be_an(Enumerator)
      expect(subject.attaches.to_a).to match_array [
        TreeDelta::Operation.new(
          type:    :attach,
          id:      "x",
          parent:  "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type:    :attach,
          id:      "z",
          parent:  "x",
          position: 0
        ),
        TreeDelta::Operation.new(
          type:    :attach,
          id:      "e",
          parent:  "a",
          position: 2
        ),
        TreeDelta::Operation.new(
          type:    :attach,
          id:      "b",
          parent:  "e",
          position: 0
        ),
        TreeDelta::Operation.new(
          type:    :attach,
          id:      "f",
          parent:  "e",
          position: 1
        )
      ]
    end
  end

end
