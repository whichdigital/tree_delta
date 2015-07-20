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

  it 'can delete 2 leaf nodes with the same parent' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
                  / \
                 f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'e'
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'd'
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

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'g'
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'd'
      )
    ]
  end

  it 'can delete 2 non-leaf nodes' do
    to = AsciiTree.parse('
            (  a  )
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'c'
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'b'
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

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'f'
      ),
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'b'
      )
    ]
  end
end
