# inventmn: ResetAddress draft form

The guarded `CInventUserData::ResetAddress` draft declares the
`char (*work)[0x2000]` row pointer first, initializes the photo index to zero,
then assigns the pointer from `photo_work`; each iteration is
`photo[index].image = work[index]`. Initializing the index before declaring
the row pointer changes the register map; a `<= 29` bound or a `do` loop
changes the unroll and remainder lowering and loses retail's eight-way
unrolled body. The remaining differences are the invariant-base setup and the
two-photo tail described in [notes.md](notes.md).
