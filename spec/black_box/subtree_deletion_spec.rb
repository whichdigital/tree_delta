require 'spec_helper'

RSpec.describe TreeDelta do
  subject { described_class.new(from: from, to: to) }

  let(:from) do
    AsciiTree.parse('
            a
            |
           (b)
          / | \
         c  d  e
    ')
  end

  let(:to) do
    AsciiTree.parse('a')
  end

  it 'does not issue additional deletes for nodes in the subtree' do
    expect(subject.to_a).to eq [
      TreeDelta::Operation.new(
        type: :delete,
        identity: 'b'
      ),
    ]
  end

end
