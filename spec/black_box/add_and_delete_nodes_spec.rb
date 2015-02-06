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

  it 'can delete first leaf node and add a node to its sibling' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
            \     / \
             e   f   g
             |
             h
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'e',
        position: 0
      )
    ]
  end

  it 'can delete first non-leaf node, first leaf node of the 2nd non-leaf node and add a node to the last leaf node' do
    to = AsciiTree.parse('
            (  a  )
                  \
                   c
                    \
                     g
                     |
                     h
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'f',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'e',
        parent: 'b',
        position: 1,
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd',
        parent: 'b',
        position: 0,
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b',
        parent: 'a',
        position: 0,
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'g',
        position: 0,
      )
    ]
  end

  it 'can delete a non-leaf node and a add a leaf node to the root as middle child' do
    to = AsciiTree.parse('
            (  a  )
               |  \
               h   c
                  / \
                 f   g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'e',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd',
        parent: 'b',
        position: 1,
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b',
        parent: 'a',
        position: 0,
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: 'h',
        parent: 'a',
        position: 0
      )
    ]
  end
end