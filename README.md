## Tree Delta

[![Build Status](https://travis-ci.org/whichdigital/tree_delta.svg?branch=master)](https://travis-ci.org/whichdigital/tree_delta)

Calculates the minimum set of operations that transform one tree into another.

## Overview

Let's say we have the following ordered trees:

```
                             alpha               beta
                             /   \               /  \
                            a     b             a    e
                           / \     \           / \
                          c   d     e         d   c
```

You can transform the 'alpha' tree into the 'beta' tree through a combination
of operations:

```
create - adds a node to the tree
update - changes the attributes of a node
delete - removes a node from the tree
detach - orphan a node from its parent
attach - give a node a new parent
```

Here are the operations for the above example:

```
detach 'e'
detach 'd'
detach 'a'
delete 'alpha'
create 'beta' as root
attach 'a' to 'beta' at position 0
attach 'd' to 'a' at position 0
attach 'e' to 'beta' at position 1
```

The order of these operations is somewhat important. For example, node 'a' can
only be attached to 'beta' after 'beta' has been created.

Updates are not shown here. An 'update' operation is used to make changes to the
value object for a node. This is where you'd store the node's attributes.

## Usage

You must first define a node class with the following methods:

```ruby
#identity
Returns an identifier that uniquely identifies the node across trees.

#parent
Returns the parent of the node.

#children
Returns an array of child nodes.

#value
Returns the value object associated with the node.
```

You can then use your node class to create separate trees:

```ruby
alpha = Node.new("alpha", children: [
  Node.new("a", children: [
    Node.new("c"),
    Node.new("d")
  ]),
  Node.new("b", children: [
    Node.new("e")
  ])
])

beta = Node.new("beta", children: [
  Node.new("a", children: [
    Node.new("d"),
    Node.new("c")
  ]),
  Node.new("e")
])
```

Finally, you can instantiate a delta from the roots of the trees:

```ruby
delta = TreeDelta.new(from: alpha, to: beta)

delta.each do |operation|
  # ...
end
```

## Operation

An operation is a simple object that describes a transformation.

It can contain up to five pieces of information, as shown here:

|          | type     | identity | value    | parent   | position |
| --------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|   create | ✓        | ✓        | ✓        | ✓        | ✓        |
|   update | ✓        | ✓        | ✓        |          |          |
|   delete | ✓        | ✓        |          |          |          |
|   detach | ✓        | ✓        |          |          |          |
|   attach | ✓        | ✓        |          | ✓        | ✓        |

Here is an example:

```ruby
operation.type
#=> :create

operation.identity
#=> "foo"

operation.value
#=> 123

operation.parent
#=> "bar"

operation.position
#=> 3
```

The 'value' is the value object for the node. This can be a literal value
or an object, such as a hash of attributes.

The 'position' refers to the node's index position relative to its siblings,
starting at zero.

The 'parent' will be nil if the node is the root of the tree.

## Assumptions

- The delta assumes that deletions cascade down to subtrees under a node. It
will not yield operations to delete descendants of a node.

- The delta assumes that positions for siblings are updated when a node is
created or attached. Any sibling to the right of the node should have its
position incremented by one.

- The delta assumes that positions for siblings are updated when a node is
deleted or detached. Any sibling to the right of the node should have its
position decremented by one.

## Contribution

If you'd like to contribute, please open an issue or submit a pull request.
