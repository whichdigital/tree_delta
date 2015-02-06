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

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can create to a non-leaf node and swap 2 non-leaf nodes' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           c     ( b )
          / \    / | \
         d   e  f  h  g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can create to a leaf node and move the leaf node to be a child of the root' do
    to = AsciiTree.parse('
            (  a  )
            /  |  \
           b   c   e
          /   / \   \
         d   f   g   h
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can create to a non-leaf node and move first sibling be a child of the root' do
    to = AsciiTree.parse('
            (    a    )
            /    |    \
           b     c     e
          / \   / \
         d   h f   g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can create to a non-leaf node and move last sibling be a child of the root' do
    to = AsciiTree.parse('
            (    a    )
            /    |    \
           b     c     d
          / \   / \
         h   e f   g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end
end