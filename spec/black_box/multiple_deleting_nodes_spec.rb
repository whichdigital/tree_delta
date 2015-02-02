require 'spec_helper'

describe TreeDelta do
  let(:from) do
    n('a',
      n('b',
        n('d'),
        n('e')
      ),
      n('c',
        n('f'),
        n('g')
      )
    )
  end

  it 'can delete 2 leaf nodes with the same parent' do
    to =
      n('a',
        n('b'),
        n('c',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: "d",
        parent: "b",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: "e",
        parent: "b",
        position: 1
      )
    ]
  end

  it 'can delete 2 leaf nodes from different parents' do
    to =
      n('a',
        n('b',
          n('e')
        ),
        n('c',
          n('f')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: "d",
        parent: "b",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: "g",
        parent: "c",
        position: 1
      )
    ]
  end

  it 'can delete 2 non-leaf nodes' do
    to =
      n('a')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: "b",
        parent: "a",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: "c",
        parent: "a",
        position: 1
      )
    ]
  end

  it 'can delete a non-leaf node and a leaf node' do
    to =
      n('a',
        n('c',
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: "b",
        parent: "a",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :delete,
        id: "f",
        parent: "c",
        position: 0
      )
    ]
  end
end