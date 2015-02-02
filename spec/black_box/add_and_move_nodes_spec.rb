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

  it 'can create to a leaf node and swap 2 non-leaf nodes' do
    to =
      n('a',
        n('c',
          n('d'),
          n('e')
        ),
        n('b',
          n('f',
            n('h')
          ),
          n('g',)
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can create to a non-leaf node and swap 2 non-leaf nodes' do
    to =
      n('a',
        n('c',
          n('d'),
          n('e')
        ),
        n('b',
          n('f'),
          n('h'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can create to a leaf node and move the leaf node to be a child of the root' do
    to =
      n('a',
        n('b',
          n('d')
        ),
        n('c',
          n('f'),
          n('g')
        ),
        n('e',
          n('h')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can create to a non-leaf node and move first sibling be a child of the root' do
    to =
      n('a',
        n('b',
          n('d'),
          n('h')
        ),
        n('c',
          n('f'),
          n('g')
        ),
        n('e')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can create to a non-leaf node and move last sibling be a child of the root' do
    to =
      n('a',
        n('b',
          n('h'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        ),
        n('d')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end
end