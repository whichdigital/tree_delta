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

  it 'can change order of a leaf nodes' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('g'),
          n('f')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: "g",
        parent: "c",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "g",
        parent: "c",
        position: 0
      )
    ]
  end

  it 'can change order of a non-leaf nodes' do
    to =
      n('a',
        n('c',
          n('f'),
          n('g')
        ),
        n('b',
          n('d'),
          n('e')
        )
      )


    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: "c",
        parent: "a",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "c",
        parent: "a",
        position: 0
      )
    ]
  end

  it 'can change order of a leaf nodes with different parents' do
    to =
      n('a',
        n('b',
          n('d'),
          n('f')
        ),
        n('c',
          n('e'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: "f",
        parent: "c",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: "e",
        parent: "b",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "f",
        parent: "b",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "e",
        parent: "c",
        position: 0
      )
    ]
  end

  it 'can move a leaf node to be the last sibling of its parent' do
    to =
      n('a',
        n('b',
          n('d')
        ),
        n('c',
          n('f'),
          n('g')
        ),
        n('e')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: "e",
        parent: "b",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "e",
        parent: "a",
        position: 2
      )
    ]
  end

  it 'can move a leaf node to be the middle sibling of its parent' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('g'),
        n('c',
          n('f')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: "g",
        parent: "c",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "g",
        parent: "a",
        position: 1
      )
    ]
  end

  it 'can move a leaf node to be the root node' do
    to =
      n('g',
        n('a',
          n('b',
            n('d'),
            n('e')
          ),
          n('c',
            n('f')
          )
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        id: "g",
        parent: "",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "g",
        parent: "",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "a",
        parent: "g",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "b",
        parent: "a",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "d",
        parent: "b",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "e",
        parent: "b",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "c",
        parent: "a",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :create,
        id: "f",
        parent: "c",
        position: 0
      )
    ]
  end

  it 'can move a node with leaf nodes to be its parents sibling' do
    # need a different from tree for this scenario
    from =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g',
            n('h'),
            n('i')
          )
        )
      )

    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('g',
          n('h'),
          n('i')
        ),
        n('c',
          n('f')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: "g",
        parent: "c",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: "h",
        parent: "g",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: "i",
        parent: "g",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "g",
        parent: "a",
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "h",
        parent: "g",
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: "i",
        parent: "g",
        position: 1
      )
    ]
  end
end