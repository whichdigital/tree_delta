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

  it 'can remove the first child node from its parent' do
    to = AsciiTree.parse('
            (  a  )
            /     \
           b       c
            \     / \
             e   f   g
    ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'd'
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

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'g'
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

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'b'
      )
    ]
  end

  it 'can remove a root node' do
    to = AsciiTree.parse(' ')

    operations = described_class.new(from: from, to: to)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'a'
      )
    ]
  end
end
