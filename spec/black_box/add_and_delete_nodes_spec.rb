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

  it 'can delete first and second leaf nodes(same parents)' do
    to =
      n('a',
        n('b'),
        n('c',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can delete first and last leaf nodes(different parents)' do
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

    expect(operations.to_a).to eq []
  end

  it 'can delete a leaf nodes and a non-leaf node' do
    to =
      n('a',
        n('c',
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end

  it 'can delete 2 non-leaf nodes' do
    to =
      n('a')

    operations = do_transform(to, from)

    expect(operations.to_a).to eq []
  end
end