require 'spec_helper'

describe TreeDelta do
  let(:from) do
    AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         d   e   f   g
    ')
  end

  it 'can swap the order of the first 2 leaf sibling nodes and 2 non-leaf sibling nodes' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
          / \     / \
         e   d   f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'b',
        position: 1
      )
    ]
  end

  it 'can swap the order of the last 2 leaf sibling nodes and 2 non-leaf sibling nodes' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
          / \     / \
         d   e   g   f
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 1
      )
    ]
  end

  it 'can swap the order of the first and last 2 leaf sibling nodes' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         e   d   g   f
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'c',
        position: 0
      )
    ]
  end

  it 'can swap the order of 2 leaf nodes with different parents' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         d   f   e   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'c',
        position: 0
      )
    ]
  end

  it 'can swap the order of 2 leaf nodes and move a different leaf node to be a child of the root' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           b   c   e
          /   / \
         d   g   f
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'a',
        position: 2
      )
    ]
  end

  it 'can swap the order of 2 leaf nodes with different parents and move a non-leaf node to be a child of the root' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           b   c   d
          /   / \
         f   e   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
        parent: 'a',
        position: 2
      )
    ]
  end

  it 'can swap the order of 2 non-leaf nodes and move a leaf node to be a child of the root' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           c   b   d
          /   / \
         e   f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
        parent: 'a',
        position: 2
      )
    ]
  end
end
