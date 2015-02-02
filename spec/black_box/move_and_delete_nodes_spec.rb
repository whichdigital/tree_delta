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

  it 'can swap 2 non-leaf nodes and delete the first child of the first moved node' do
    to =
      n('a',
        n('c',
          n('e')
        ),
        n('b',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can swap 2 non-leaf nodes and delete the second child of the first moved node' do
    to =
      n('a',
        n('c',
          n('d')
        ),
        n('b',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can swap 2 non-leaf nodes and delete the first children of the second moved node' do
    to =
      n('a',
        n('c',
          n('d'),
          n('e')
        ),
        n('b',
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can remove a leaf node and move its siblings to be a child of the root' do
    to =
      n('a',
        n('c',
          n('f'),
          n('g')
        ),
        n('d')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can remove a leaf node and move a different leaf node to be a child of the root' do
    to =
      n('a',
        n('b',
          n('e')
        ),
        n('c',
          n('g')
        ),
        n('d')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can remove a non-leaf node and move its child node to be a child of the root' do
    to =
      n('a',
        n('c',
          n('f'),
          n('g')
        ),
        n('d')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can move a leaf node to be a child of the root and remove the middle non-leaf node' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('f')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end
end