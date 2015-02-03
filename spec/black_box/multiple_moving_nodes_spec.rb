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

  it 'can swap the order of the first 2 leaf sibling nodes and 2 non-leaf sibling nodes' do
    to =
      n('a',
        n('c',
          n('e'),
          n('d')
        ),
        n('b',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'b',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'c',
        parent: 'a',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'b',
        parent: 'a',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'c',
        parent: 'a',
        position: 0
      )
    ]
    #   might need to detach and attach children to correct parent??
  end

  it 'can swap the order of the last 2 leaf sibling nodes and 2 non-leaf sibling nodes' do
    to =
      n('a',
        n('c',
          n('d'),
          n('e')
        ),
        n('b',
          n('g'),
          n('f')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'g',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'b',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'd',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'c',
        parent: 'a',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'd',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 1
      )
    ]
  end

  it 'can swap the order of the first and last 2 leaf sibling nodes' do
    to =
      n('a',
        n('b',
          n('e'),
          n('d')
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
        id: 'f',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'b',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'c',
        position: 0
      )
    ]
  end

  it 'can swap the order of 2 leaf nodes with different parents' do
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
        id: 'e',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'c',
        position: 0
      )
    ]
  end

  it 'can swap the order of 2 leaf nodes and move a different leaf node to be a child of the root' do
    to =
      n('a',
        n('b',
          n('d')
        ),
        n('c',
          n('g'),
          n('f')
        ),
        n('e')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'a',
        position: 2
      )
    ]
  end

  it 'can swap the order of 2 leaf nodes with different parents and move a non-leaf node to be a child of the root' do
    to =
      n('a',
        n('b',
          n('f')
        ),
        n('c',
          n('e'),
          n('g')
        ),
        n('d')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach,
        id: 'e',
        parent: 'b',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :detach,
        id: 'f',
        parent: 'c',
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'f',
        parent: 'c',
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'e',
        parent: 'a',
        position: 2
      )
    ]
  end

  it 'can swap the order of 2 non-leaf nodes and move a leaf node to be a child of the root' do
    to =
      n('a',
        n('c',
          n('e')
        ),
        n('b',
          n('f'),
          n('g')
        ),
        n('d')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :detach, 
        id: 'g'
      ),
      TreeDelta::Operation.new(
        type: :detach, 
        id: 'f'
      ),
      TreeDelta::Operation.new(
        type: :detach, 
        id: 'c'
      ),
      TreeDelta::Operation.new(
        type: :detach, 
        id: 'e'
      ),
      TreeDelta::Operation.new(
        type: :detach, 
        id: 'd'
      ),
      TreeDelta::Operation.new(
        type: :attach, 
        id: 'c', 
        parent: 'a', 
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach, 
        id: 'e', 
        parent: 'c', 
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach, 
        id: 'f', 
        parent: 'b', 
        position: 0
      ),
      TreeDelta::Operation.new(
        type: :attach,
        id: 'g', 
        parent: 'b', 
        position: 1
      ),
      TreeDelta::Operation.new(
        type: :attach, 
        id: 'd', 
        parent: 'a', 
        position: 2
      )
    ]
  end
end