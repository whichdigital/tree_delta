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

  it 'can create a node onto a leaf node' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         d   e   f   g
         |
         h
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'd',
        position: 0
      )
    ]
  end


  it 'can create a node onto a non-leaf node as last sibling' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b     ( c )
          / \    / | \
         d   e  f  g  h
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'c',
        position: 2
      )
    ]
  end

  it 'can create a node onto a non-leaf node between siblings' do
    to = AsciiTree.parse('
            (  a  )
            /     \
         ( b )     c
         / | \    / \
        d  h  e  f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'b',
        position: 1
      )
    ]
  end

  it 'can create a node onto the root node between sibling' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           b   h   c
          / \     / \
         d   e   f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'a',
        position: 1
      )
    ]
  end

  it 'can create a node onto the root node as last sibling' do
    to = AsciiTree.parse('
            (    a    )
            /    |    \
           b     c     h
          / \   / \
         d   e f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        parent: 'a',
        position: 2
      )
    ]
  end

  it 'can create a node as root' do
    to = AsciiTree.parse('
               h
               |
            (  a  )
            /     \
           b       c
          / \     / \
         d   e   f   g
    ')
    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        identity: 'h',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        identity: 'a',
        parent: 'h',
        position: 0
      )
    ]
  end
end
