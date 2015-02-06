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

  it 'can change order of a leaf nodes' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         d   e   g   f
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'c',
        position: 0
      )
    ]
  end

  it 'can change order of a non-leaf nodes' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c       b
          / \     / \
         f   g   d   e
    ')


    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'c',
        parent: 'a',
        position: 0
      )
    ]
  end

  it 'can change order of a leaf nodes with different parents' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         d   f   e   g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f',
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e',
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

  it 'can move a leaf node to be the last sibling of its parent' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           b   c   e
          /   / \
         d   f   g
    ')

    operations = do_transform(to, from)

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
      )
    ]
  end

  it 'can move a leaf node to be the middle sibling of its parent' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           b   g   c
          / \     /
         d   e   f
    ')
    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'a',
        position: 1
      )
    ]
  end

  it 'can move a leaf node to be the root node' do
    to = AsciiTree.parse('
               g
               |
            (  a  )
            /     \
           b       c
          / \     /
         d   e   f
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'a',
        parent: 'g',
        position: 0
      )
    ]
  end

  it 'can move a node with leaf nodes to be its parents sibling' do
    # need a different from tree for this scenario
    from = AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     / \
         d   e   f   g
                    / \
                   h   i
    ')

    to = AsciiTree.parse('
            (     a     )
            /     |     \
           b      g      c
          / \    / \    /
         d   e  h   i  f


    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g',
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'a',
        position: 1
      )
    ]
  end
end
