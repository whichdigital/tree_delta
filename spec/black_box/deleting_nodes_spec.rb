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

  it 'can remove the first child node from its parent' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
            \     / \
             e   f   g
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'd',
        parent: 'b',
        position: 0
      )
    ]
  end

  it 'can remove the last child node from its parent' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
          / \     /
         d   e   f
    ')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: 'g',
        parent: 'c',
        position: 1
      )
    ]
  end

  it 'can remove a non-leaf node' do
    to = AsciiTree.parse('
            (  a  )
                  \
                   c
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
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b',
        parent: 'a',
        position: 1
      )
    ]
  end

  it 'can remove a root node' do
    to = AsciiTree.parse(' ')

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
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'b',
        parent: 'a',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'g',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'f',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: 'a',
        parent: '',
        position: 0
      )
    ]
  end
end