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

  it 'can swap 2 non-leaf nodes and delete the first child of the first moved node' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
            \     / \
             e   f   g
    ')

    operations = do_transform(to, from)

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
        type: :delete,
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

    operations = do_transform(to, from)

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
        type: :delete,
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

  it 'can swap 2 non-leaf nodes and delete the first children of the second moved node' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
          / \       \
         d   e       g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g',
      ),
      TreeDelta::Operation.new(
        type: :delete,
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
        id: 'g',
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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'f',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f',
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'c',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'a',
        position: 1
      )
    ]
  end
end