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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
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
    operations = do_transform(to, from)

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
        type: :detach,
        id: 'b'
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'a'
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        position: 0,
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'a',
        parent: 'h',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'b',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'c',
        parent: 'a',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'c',
        position: 1
      )
    ]
  end
end