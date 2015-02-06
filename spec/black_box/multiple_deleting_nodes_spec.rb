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

  it 'can delete 2 leaf nodes with the same parent' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
                  / \
                 f   g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd'
      )
    ]
  end

  it 'can delete 2 leaf nodes from different parents' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
            \     /
             e   f
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd'
      )
    ]
  end

  it 'can delete 2 non-leaf nodes' do
    to = AsciiTree.parse('
            (  a  )
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b'
      )
    ]
  end

  it 'can delete a non-leaf node and a leaf node' do
    to =  AsciiTree.parse('
            (  a  )
                  \
                   c
                    \
                     g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b'
      )
    ]
  end
end