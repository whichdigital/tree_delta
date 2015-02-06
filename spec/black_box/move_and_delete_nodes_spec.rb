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

    expect(operations.to_a).to eq []
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

    expect(operations.to_a).to eq []
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

    expect(operations.to_a).to eq []
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

    expect(operations.to_a).to eq []
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

    expect(operations.to_a).to eq []
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

    expect(operations.to_a).to eq []
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

    expect(operations.to_a).to eq []
  end
end