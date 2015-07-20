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
        identity: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'f',
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
        identity: 'f',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'g',
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
        identity: 'e'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'e',
        parent: 'a',
        position: 2
      ),
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
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
        identity: 'e'
      ),
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'e',
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
        identity: 'd'
      ),
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'd',
        parent: 'a',
        position: 2
      )
    ]
  end
end
