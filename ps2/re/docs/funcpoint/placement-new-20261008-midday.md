# Placement-new constructor classes

The [constructor classification](placement-new.md#constructor-inline-classification) is
the basis for scalar placement allocation guards: a statement-inline (class 3)
constructor converts construction before the usual late expression lowering, while
small constructors without control flow or member arrays stay expression-inline
(class 6). Menu constructors with genuine member arrays take class 3; the point/list,
frame, character and collision constructors have no such array and no conditional body,
and no artificial loop, destructor-bearing local, singleton array, identity helper or
hand-written vtable store may be introduced to force the class.

Generated frame-attribute assignment reproduces manual copy instructions but leaves an
allocation branch unchanged. An identity helper (`Ident`) is not a valid matching
mechanism, and the compiler-generated object copy constructor cannot be independently
emitted by a dummy use.
