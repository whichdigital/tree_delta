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

  it 'can create a node onto a leaf node' do
    to =
      n('a',
        n('b',
          n('d',
            n('h')
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
        value: "value",
        id: "h",
        parent: "d",
        position: 0
      )
    ]
  end


  it 'can create a node onto a non-leaf node as last sibling' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g'),
          n('h')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        value: "value",
        id: "h",
        parent: "c",
        position: 2
      )
    ]
  end

  it 'can create a node onto a non-leaf node between siblings' do
    to =
      n('a',
        n('b',
          n('d'),
          n('h'),
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
        value: "value",
        id: "h",
        parent: "b",
        position: 1
      )
    ]
  end

  it 'can create a node onto the root node between sibling' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('h'),
        n('c',
          n('f'),
          n('g')
        )
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        value: "value",
        id: "h",
        parent: "a",
        position: 1
      )
    ]
  end

  it 'can create a node onto the root node as last sibling' do
    to =
      n('a',
        n('b',
          n('d'),
          n('e')
        ),
        n('c',
          n('f'),
          n('g')
        ),
        n('h')
      )

    operations = do_transform(to, from)

    expect(operations.to_a).to eq [
      TreeDelta::Operation.new(
        type: :create,
        value: "value",
        id: "h",
        parent: "a",
        position: 2
      )
    ]
  end

  it 'can create a node as root' do
    to =
      n('h',
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
      )
    operations = do_transform(to, from)

    expect(operations.to_a).to eq [

    ]
    # 	unsure about the Operation for this, its not just a normal create
  end
end