require 'spec_helper'

RSpec.describe TreeDelta do
  let(:from) do
    AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         d   e   f   g
    ')
  end

  it 'can swap 2 non-leaf nodes and delete the first child of the first moved node' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
            \     / \
             e   f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'g',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'f',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'c',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'e',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'd',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'e',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'g',
        parent: 'b',
        position: 1
      )
    ]
  end

  it 'can swap 2 non-leaf nodes and delete the second child of the first moved node' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
          /       / \
         d       f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'g',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'f',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'c',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'e',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'd',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'd',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'g',
        parent: 'b',
        position: 1
      )
    ]
  end

  it 'can swap 2 non-leaf nodes and delete the first children of the second moved node' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
          / \       \
         d   e       g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'g',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'f',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'c',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'e',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'd',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'd',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'e',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'g',
        parent: 'b',
        position: 0
      )
    ]
  end

  it 'can remove a leaf node and move its siblings to be a child of the root' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       d
          / \
         f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'd',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'b',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'd',
        parent: 'a',
        position: 1
      )
    ]
  end

  it 'can remove a leaf node and move a different leaf node to be a child of the root' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           b   c   d
          /    |
         e     g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'f',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'd',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'd',
        parent: 'a',
        position: 2
      )
    ]
  end

  it 'can remove a non-leaf node and move its child node to be a child of the root' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       d
          / \
         f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'd',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'b',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'd',
        parent: 'a',
        position: 1
      )
    ]
  end

  it 'can move a leaf node to be a child of the root and remove the middle non-leaf node' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       f
          / \
         d   e
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        identity: 'f',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'c',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'f',
        parent: 'a',
        position: 1
      )
    ]
  end
end
