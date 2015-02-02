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

  it 'can create 2 consecutive nodes to a leaf node' do
    to =
      n('a',
        n('b',
          n('d',
            n('h',
              n('i')
            )
          ),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: "h",
        parent: "d",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "i",
        parent: "h",
        position: 0
      )
    ]
  end

  it 'can create 2 consecutive nodes to a non-leaf node' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e'),
          n('h',
            n('i')
          )
        ),
        n('c',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: "h",
        parent: "b",
        position: 2
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "i",
        parent: "h",
        position: 0
      )
    ]
  end

  it 'can create 2 consecutive nodes to a root node' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('h',
          n('i')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: "h",
        parent: "a",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "i",
        parent: "h",
        position: 0
      )
    ]
  end

  it 'can create 2 nodes in the middle of the children of a non-leaf node' do
    to =
      n('a',
        n('b',
          n('d'),
          n('h'),
          n('i'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: "h",
        parent: "b",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "i",
        parent: "b",
        position: 2
      )
    ]
  end

  it 'can create 2 nodes one to the root and one to a non-leaf node' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('h'),
        n('c',
          n('f'),
          n('i'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        id: "h",
        parent: "a",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "i",
        parent: "c",
        position: 1
      )
    ]
  end
end