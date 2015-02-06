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

  it 'can create to a leaf node and swap 2 non-leaf nodes' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
          / \     / \
         d   e   f   g
                 |
                 h
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd',
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
        id: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'f',
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

  it 'can create to a non-leaf node and swap 2 non-leaf nodes' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c     ( b )
          / \    / | \
         d   e  f  h  g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd',
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
        id: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'b',
        position: 2
      )
    ]
  end

  it 'can create to a leaf node and move the leaf node to be a child of the root' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           b   c   e
          /   / \   \
         d   f   g   h
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'a',
        position: 2
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'e',
        position: 0
      )
    ]
  end

  it 'can create to a non-leaf node and move first sibling be a child of the root' do
    to = AsciiTree.parse('
            (    a    )
            /    |    \
           b     c     e
          / \   / \
         d   h f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'a',
        position: 2
      )
    ]
  end

  it 'can create to a non-leaf node and move last sibling be a child of the root' do
    to = AsciiTree.parse('
            (    a    )
            /    |    \
           b     c     d
          / \   / \
         h   e f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd'
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'b',
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
end
