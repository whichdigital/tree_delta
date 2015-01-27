require "spec_helper"

describe TreeDelta::Traversal do
  subject do
    described_class.new(type: type, direction: direction, order: order)
  end

  let(:tree) do
    n("root",
      n("a",
        n("c"),
        n("d")
       ),
       n("b",
         n("e")
        )
     )
  end

  let(:ids) { subject.traverse(tree).map(&:id) }

  it "enumerates an empty array when given nil" do
    traversal = described_class.new(
      type:      :depth_first,
      direction: :left_to_right,
      order:     :pre
    )

    enumerator = traversal.traverse(nil)

    expect(enumerator).to be_an(Enumerator)
    expect(enumerator.to_a).to eq []
  end

  describe "depth-first" do
    let(:type) { :depth_first }

    describe "left-to-right" do
      let(:direction) { :left_to_right }

      describe "pre-order" do
        let(:order) { :pre }

        it "traverses in the correct order" do
          expect(ids).to eq ["root", "a", "c", "d", "b", "e"]
        end
      end

      describe "post-order" do
        let(:order) { :post }

        it "traverses in the correct order" do
          expect(ids).to eq ["c", "d", "a", "e", "b", "root"]
        end
      end
    end

    describe "right-to-left" do
      let(:direction) { :right_to_left }

      describe "pre-order" do
        let(:order) { :pre }

        it "traverses in the correct order" do
          expect(ids).to eq ["root", "b", "e", "a", "d", "c"]
        end
      end

      describe "post-order" do
        let(:order) { :post }

        it "traverses in the correct order" do
          expect(ids).to eq ["e", "b", "d", "c", "a", "root"]
        end
      end
    end
  end

  describe "breadth-first" do
    let(:type) { :breadth_first }

    describe "left-to-right" do
      let(:direction) { :left_to_right }

      describe "pre-order" do
        let(:order) { :pre }

        pending
      end

      describe "post-order" do
        let(:order) { :post }

        pending
      end
    end

    describe "right-to-left" do
      let(:direction) { :right_to_left }

      describe "pre-order" do
        let(:order) { :pre }

        pending
      end

      describe "post-order" do
        let(:order) { :post }

        pending
      end
    end
  end

end
