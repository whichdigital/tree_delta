require "spec_helper"

RSpec.describe TreeDelta::Intermediate do
  subject { described_class.new(from: from, to: to) }

  let(:from) do
    AsciiTree.parse('
            (   a   )
            / | |   \
         b{1} d c{2} x
         /  \       / \
        e    f     y   z
    ')
  end

  let(:to) do
    AsciiTree.parse('
           (    a    )
           /  |  \   \
          x  c{4} (e) g
         / \      / \
        z   y   b{3} f
    ')
  end

  describe "#creates" do
    it "enumerates create operations" do
      expect(subject.creates).to be_an(Enumerator)
      expect(subject.creates.to_a).to match_array [
        TreeDelta::Operation.new(
          type:     :create,
          identity: "g",
          parent:   "a",
          position: 3
        )
      ]
    end
  end

  describe "#updates" do
    it "enumerates update operations" do
      expect(subject.updates).to be_an(Enumerator)
      expect(subject.updates.to_a).to match_array [
        TreeDelta::Operation.new(
          type:  :update,
          identity: "b",
          value: 3,
        ),
        TreeDelta::Operation.new(
          type:  :update,
          identity: "c",
          value: 4
        ),
      ]
    end
  end

  describe "#deletes" do
    it "enumerates delete operations" do
      expect(subject.deletes).to be_an(Enumerator)
      expect(subject.deletes.to_a).to match_array [
        TreeDelta::Operation.new(
          type: :delete,
          identity: "d"
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
          identity: "z",
        ),
        TreeDelta::Operation.new(
          type: :detach,
          identity: "x",
        ),
        TreeDelta::Operation.new(
          type: :detach,
          identity: "f",
        ),
        TreeDelta::Operation.new(
          type: :detach,
          identity: "e",
        ),
        TreeDelta::Operation.new(
          type: :detach,
          identity: "b",
        )
      ]
    end
  end

  describe "#attaches" do
    it "enumerates attach operations" do
      expect(subject.attaches).to be_an(Enumerator)
      expect(subject.attaches.to_a).to match_array [
        TreeDelta::Operation.new(
          type:     :attach,
          identity: "x",
          parent:   "a",
          position:  0
        ),
        TreeDelta::Operation.new(
          type:     :attach,
          identity: "z",
          parent:   "x",
          position:  0
        ),
        TreeDelta::Operation.new(
          type:     :attach,
          identity: "e",
          parent:   "a",
          position:  2
        ),
        TreeDelta::Operation.new(
          type:     :attach,
          identity: "b",
          parent:   "e",
          position:  0
        ),
        TreeDelta::Operation.new(
          type:     :attach,
          identity: "f",
          parent:   "e",
          position:  1
        )
      ]
    end
  end

end
