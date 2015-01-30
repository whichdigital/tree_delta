# Every scenario starts with this hierarchy
#       a
#     /   \
#    b     c
#   / \   / \
#  d   e f   g
#
# Apart from move and delete which should have this structure
#        o
#      /   \
#     o     o
#    / \   / \
#   o  o  o  o
#  /
# o
require 'spec_helper'

describe TreeDelta do
  subject { described_class.new(from: from, to: to) }

  context 'Adding nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end

    it 'can add a node onto a leaf node' do
      let(:to) do
        n('a',
          n('b',
            n('d',
              n('h')
            ),
            n('e')
          ),
          n('c',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "d",
          position: 0
        )
      ]
    end

    it 'can add a node onto a non-leaf node as last sibling' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('c',
            n('f'),
            n('g'),
            n('h')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "c",
          position: 2
        )
      ]
    end

    it 'can add a node onto a non-leaf node between siblings' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('h'),
            n('e')
          ),
          n('c',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "b",
          position: 1
        )
      ]
    end

    it 'can add a node onto the root node between sibling' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('h'),
          n('c',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "a",
          position: 1
        )
      ]
    end

    it 'can add a node onto the root node as last sibling' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('c',
            n('f'),
            n('g')
          ),
          n('h')
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "a",
          position: 2
        )
      ]
    end

    it 'can add a node as root' do
      let(:to) do
        n('h',
          n('a',
            n('b',
              n('d'),
              n('e')
            ),
            n('c',
              n('f'),
              n('g')
            )
          )
        )

        # 	unsure about the Operation for this, its not just a normal add
      end
    end
  end

  context 'Deleting nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end

    it 'can remove the first child node from its parent' do
      let(:to) do
        n('a',
          n('b',
            n('e')
          ),
          n('c',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "d",
          parent: "b",
          position: 0
        )
      ]
    end

    it 'can remove the last child node from its parent' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('c',
            n('f')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "g",
          parent: "c",
          position: 1
        )
      ]
    end

    it 'can remove a non-leaf node' do
      let(:to) do
        n('a',
          n('c',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "d",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "b",
          parent: "a",
          position: 1
        )
      ]
    end

    it 'can remove a root node' do
      let(:to) do
        # Not sure how we can show a deleted full tree
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "d",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "b",
          parent: "a",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "g",
          parent: "c",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "f",
          parent: "c",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "c",
          parent: "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "a",
          parent: "",
          position: 0
        )
      ]
    end
  end

  context 'Moving nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end

    it 'can change order of a leaf nodes' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('c',
            n('g'),
            n('f')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "g",
          parent: "c",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "g",
          parent: "c",
          position: 0
        )
      ]
    end

    it 'can change order of a non-leaf nodes' do
      let(:to) do
        n('a',
          n('c',
            n('f'),
            n('g')
          ),
          n('b',
            n('d'),
            n('e')
          )
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "c",
          parent: "a",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "c",
          parent: "a",
          position: 0
        )
      ]
    end

    it 'can change order of a leaf nodes with different parents' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('f')
          ),
          n('c',
            n('e'),
            n('g')
          )
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "f",
          parent: "c",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "f",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "e",
          parent: "c",
          position: 0
        )
      ]
    end

    it 'can move a leaf node to be the last sibling of its parent' do
      let(:to) do
        n('a',
          n('b',
            n('d')
          ),
          n('c',
            n('f'),
            n('g')
          ),
          n('e')
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "e",
          parent: "a",
          position: 2
        )
      ]
    end

    it 'can move a leaf node to be the middle sibling of its parent' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('g'),
          n('c',
            n('f')
          )
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "g",
          parent: "c",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "g",
          parent: "a",
          position: 1
        )
      ]
    end

    it 'can move a leaf node to be the root node' do
      let(:to) do
        n('g',
          n('a',
            n('b',
              n('d'),
              n('e')
            ),
            n('c',
              n('f')
            )
          )
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "g",
          parent: "",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "g",
          parent: "",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "a",
          parent: "g",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "b",
          parent: "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "d",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "e",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "c",
          parent: "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "f",
          parent: "c",
          position: 0
        )
      ]
    end

    it 'can move a node with leaf nodes to be its parents sibling' do
      # need a different from tree for this scenario
      let(:from) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('c',
            n('f'),
            n('g',
              n('h'),
              n('i')
            )
          )
        )
      end

      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('g',
            n('h'),
            n('i')
          ),
          n('c',
            n('f')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "g",
          parent: "c",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "h",
          parent: "g",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "i",
          parent: "g",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "g",
          parent: "a",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "h",
          parent: "g",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "i",
          parent: "g",
          position: 1
        )
      ]

    end
  end

  context 'Multiple adding nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end

    it 'can add 2 consecutive nodes to a leaf node' do
      let(:to) do
        n('a',
          n('b',
            n('d',
              n('h',
                n('i')
              )
            ),
            n('e')
          ),
          n('c',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "d",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "i",
          parent: "h",
          position: 0
        )
      ]
    end

    it 'can add 2 consecutive nodes to a non-leaf node' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e'),
            n('h',
              n('i')
            )
          ),
          n('c',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "b",
          position: 2
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "i",
          parent: "h",
          position: 0
        )
      ]
    end

    it 'can add 2 consecutive nodes to a root node' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('h',
            n('i')
          ),
          n('c',
            n('f'),
            n('g')
          )
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "a",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "i",
          parent: "h",
          position: 0
        )
      ]
    end

    it 'can add 2 nodes in the middle of the children of a non-leaf node' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('h'),
            n('i'),
            n('e')
          ),
          n('c',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "i",
          parent: "b",
          position: 2
        )
      ]
    end

    it 'can add 2 nodes one to the root and one to a non-leaf node' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('h'),
          n('c',
            n('f'),
            n('i'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :add,
          id: "h",
          parent: "a",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :add,
          id: "i",
          parent: "c",
          position: 1
        )
      ]
    end
  end

  context 'Multiple deleting nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end

    it 'can delete 2 leaf nodes with the same parent' do
      let(:to) do
        n('a',
          n('b'),
          n('c',
            n('f'),
            n('g')
          )
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "d",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "e",
          parent: "b",
          position: 1
        )
      ]
    end

    it 'can delete 2 leaf nodes from different parents' do
      let(:to) do
        n('a',
          n('b',
            n('e')
          ),
          n('c',
            n('f')
          )
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "d",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "g",
          parent: "c",
          position: 1
        )
      ]
    end

    it 'can delete 2 non-leaf nodes' do
      let(:to) do
        n('a')
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "b",
          parent: "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "c",
          parent: "a",
          position: 1
        )
      ]
    end

    it 'can delete a non-leaf node and a leaf node' do
      let(:to) do
        n('a',
          n('c',
            n('g')
          )
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :delete,
          id: "b",
          parent: "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :delete,
          id: "f",
          parent: "c",
          position: 0
        )
      ]
    end

  end

  context 'Multiple move nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end

    it 'can swap the order of the first 2 leaf sibling nodes and 2 non-leaf sibling nodes' do
      let(:to) do
        n('a',
          n('c',
            n('e'),
            n('d')
          ),
          n('b',
            n('f'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "b",
          parent: "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "c",
          parent: "a",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "b",
          parent: "a",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "c",
          parent: "a",
          position: 0
        )
      ]
    #   might need to detach and attach children to correct parent??
    end

    it 'can swap the order of the last 2 leaf sibling nodes and 2 non-leaf sibling nodes' do
      let(:to) do
        n('a',
          n('c',
            n('d'),
            n('e')
          ),
          n('b',
            n('g'),
            n('f')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "f",
          parent: "c",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "g",
          parent: "c",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "b",
          parent: "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "d",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "c",
          parent: "a",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "d",
          parent: "c",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "e",
          parent: "c",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "g",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "f",
          parent: "b",
          position: 1
        )
      ]
    end

    it 'can swap the order of the first and last 2 leaf sibling nodes' do
      let(:to) do
        n('a',
          n('b',
            n('e'),
            n('d')
          ),
          n('c',
            n('g'),
            n('f')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "f",
          parent: "c",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "e",
          parent: "b",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "f",
          parent: "c",
          position: 0
        )
      ]
    end

    it 'can swap the order of 2 leaf nodes with different parents' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('f')
          ),
          n('c',
            n('e'),
            n('g')
          )
        )
      end

      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "f",
          parent: "c",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "f",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "e",
          parent: "c",
          position: 0
        )
      ]
    end

    it 'can swap the order of 2 leaf nodes and move a different leaf node to be a child of the root' do
      let(:to) do
        n('a',
          n('b',
            n('d')
          ),
          n('c',
            n('g'),
            n('f')
          ),
          n('e')
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "f",
          parent: "c",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "f",
          parent: "c",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "e",
          parent: "a",
          position: 2
        )
      ]
    end

    it 'can swap the order of 2 leaf nodes with different parents and move a non-leaf node to be a child of the root' do
      let(:to) do
        n('a',
          n('b',
            n('f')
          ),
          n('c',
            n('e'),
            n('g')
          ),
          n('d')
        )
      end
      expect(subject.to_a).to eq [
        TreeDelta::Operation.new(
          type: :detach,
          id: "e",
          parent: "b",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :detach,
          id: "f",
          parent: "c",
          position: 1
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "f",
          parent: "c",
          position: 0
        ),
        TreeDelta::Operation.new(
          type: :attach,
          id: "e",
          parent: "a",
          position: 2
        )
      ]
    end

    it 'can swap the order of 2 non-leaf nodes and move a leaf node to be a child of the root' do
      let(:to) do
        n('a',
          n('c',
            n('e')
          ),
          n('b',
            n('f'),
            n('g')
          ),
          n('d')
        )
      end
    end
  end

  context 'Add and delete nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end

    it 'can delete first and second leaf nodes(same parents)' do
      let(:to) do
        n('a',
          n('b'),
          n('c',
            n('f'),
            n('g')
          )
        )
      end
    end

    it 'can delete first and last leaf nodes(different parents)' do
      let(:to) do
        n('a',
          n('b',
            n('e')
          ),
          n('c',
            n('f')
          )
        )
      end
    end

    it 'can delete a leaf nodes and a non-leaf node' do
      let(:to) do
        n('a',
          n('c',
            n('g')
          )
        )
      end
    end

    it 'can delete 2 non-leaf nodes' do
      let(:to) do
        n('a')
      end
    end
  end

  context 'Add and move nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end
    it 'can add to a leaf node and swap 2 non-leaf nodes' do
      let(:to) do
        n('a',
          n('c',
            n('d'),
            n('e')
          ),
          n('b',
            n('f',
              n('h')
            ),
            n('g',)
          )
        )
      end
    end

    it 'can add to a non-leaf node and swap 2 non-leaf nodes' do
      let(:to) do
        n('a',
          n('c',
            n('d'),
            n('e')
          ),
          n('b',
            n('f'),
            n('h'),
            n('g')
          )
        )
      end
    end

    it 'can add to a leaf node and move the leaf node to be a child of the root' do
      let(:to) do
        n('a',
          n('b',
            n('d')
          ),
          n('c',
            n('f'),
            n('g')
          ),
          n('e',
            n('h')
          )
        )
      end
    end

    it 'can add to a non-leaf node and move first sibling be a child of the root' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('h')
          ),
          n('c',
            n('f'),
            n('g')
          ),
          n('e')
        )
      end
    end

    it 'can add to a non-leaf node and move last sibling be a child of the root' do
      let(:to) do
        n('a',
          n('b',
            n('h'),
            n('e')
          ),
          n('c',
            n('f'),
            n('g')
          ),
          n('d')
        )
      end
    end
  end

  context 'Move and delete nodes' do
    let(:from) do
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )
    end
    it 'can swap 2 non-leaf nodes and delete the first child of the first moved node' do
      let(:to) do
        n('a',
          n('c',
            n('e')
          ),
          n('b',
            n('f'),
            n('g')
          )
        )
      end
    end

    it 'can swap 2 non-leaf nodes and delete the second child of the first moved node' do
      let(:to) do
        n('a',
          n('c',
            n('d')
          ),
          n('b',
            n('f'),
            n('g')
          )
        )
      end
    end

    it 'can swap 2 non-leaf nodes and delete the first children of the second moved node' do
      let(:to) do
        n('a',
          n('c',
            n('d'),
            n('e')
          ),
          n('b',
            n('g')
          )
        )
      end
    end

    it 'can remove a leaf node and move its siblings to be a child of the root' do
      let(:to) do
        n('a',
          n('c',
            n('f'),
            n('g')
          ),
          n('d')
        )
      end
    end

    it 'can remove a leaf node and move a different leaf node to be a child of the root' do
      let(:to) do
        n('a',
          n('b',
            n('e')
          ),
          n('c',
            n('g')
          ),
          n('d')
        )
      end
    end

    it 'can remove a non-leaf node and move its child node to be a child of the root' do
      let(:to) do
        n('a',
          n('c',
            n('f'),
            n('g')
          ),
          n('d')
        )
      end
    end

    it 'can move a leaf node to be a child of the root and remove the middle non-leaf node' do
      let(:to) do
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('f')
        )
      end
    end

  end
end
