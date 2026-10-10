# Satan's Fiddle compiler integration

The PS2 game units use MWCC 3.0-011126 through Satan's Fiddle. The linker uses
plain `wibo`; library and data-only assembly use GNU `as`. The Docker image
builds a pinned Satan's Fiddle revision and includes LLDB and an unstripped
`wibo`, so local container builds and CI use the same compiler wrapper. For
builds outside the container, build Satan's Fiddle with its documented Linux,
Rust, LLDB and unstripped `wibo` prerequisites.

Objdiff's source-only base objects use the same adapter, profile, options and
logical translation-unit name as the linked objects. They omit mwccgap so
assembly fallbacks remain absent from the native-code metric. The generated
objdiff configuration reads actual base-object symbols and maps sanitized retail
template identities to MWCC's original template spelling.

Scalar placement construction can request MWCC's ordinary statement conversion
through an explicit frontend policy. Its mechanism, calibrated rows and limits
are documented in [the design note](../../ps2/re/docs/satansfiddle/placement-new.md).

```sh
export SATANSFIDDLE=/absolute/path/to/satansfiddle
export WIBO_PATH=/absolute/path/to/unstripped/wibo
./build.sh
```

The default profile is `scripts/build/satansfiddle.json`, outside the generated
`ps2/config` tree. `SATANSFIDDLE_CONFIG` can select another JSON profile. Its
compiler version is a consistency check: Satan's Fiddle still verifies the
compiler executable's SHA-256 and the hook signatures. The checked-in profile
starts helper-call history at zero and initializes the floating-point
evaluate-first annotation to false. These deterministic settings establish a
repeatable baseline; matching retail can require documented per-unit overrides.
There is no statefix dependency.

The checked-in translation-unit rows replace artificial discarded helper
functions with measured compiler history: GPR mask `0x30` for the selected units
and `0x10` for `nd_meswin.cpp`, with FPR mask zero. Calibration checks the complete
allocated object and resolved relocation identities, so a pre-existing mismatch
cannot conceal a new change. These rows describe compiler state, not additional
game functions.

`scripts/build/mwccgap.sh` supplies `satansfiddle-wibo.py` as mwccgap's
`--wibo-path`. For each of mwccgap's two passes, the adapter preserves every
compiler option and its argument boundary, separates the generated `-o OBJECT`
and source arguments, and creates a private JSON configuration. The compiler
path and options come from that invocation. The adapter passes the original
source basename with `--translation-unit`, so the temporary `.c` in the second
pass selects the same helper masks and floating-point identities. It retains
the actual source path for quoted includes and dependency generation.

Expression overrides identify a translation unit, mangled function, binary32 or
binary64 type and IEEE value bits. An optional `callee` narrows the identity to
arguments of that mangled call target. Each row applies to every occurrence of
its resulting identity. For example, the three `1.0f` arguments in
`_SET_CROSSFADE` need different scheduling: only `CrossFadeOut` is evaluated
first. Its row is:

```json
{
  "translation_unit": "event_func.cpp",
  "function": "_SET_CROSSFADE__FP12RS_STACKDATAi",
  "value_type": "binary32",
  "value_bits": "0x3f800000",
  "callee": "CrossFadeOut__10CFadeInOutFiif",
  "evaluate_first": true
}
```

The pinned compiler receives the checked-in
`patches/satansfiddle-nested-arguments.patch` during the Docker build. Its
optional `nested_call` selector identifies a sibling call by mangled callee
and an inner argument's formal index, floating type, and IEEE bits. The
optional `nested_variable` selector identifies a nonliteral variable load at
an inner argument index. Both require an outer `callee`; neither uses an
occurrence number or output address. For example, `RoboWalkMoveIF` selects
the `SetRotation` zero associated with `unitRotation`'s third argument 16.0f,
while `RoboAirMoveIF` selects the zero associated with a local angle passed
as `unitRotation`'s second argument.

The subsequent `patches/satansfiddle-control-context.patch` adds two optional
source identities for verified MWCC 3.0 statement lowering. `control` identifies
the integer value set of an enclosing equality condition or grouped switch case;
`argument` identifies a sibling floating constant by its formal position, type,
and IEEE bits. Both require `callee`. For example, the two `_SHOT` alpha calls
share their callee and 160.0f value, but only the attack-type-90 condition needs
early evaluation:

```json
{
  "translation_unit": "actscript.cpp",
  "function": "_SHOT__FP12RS_STACKDATAi",
  "value_type": "binary32",
  "value_bits": "0x43200000",
  "callee": "SetValue__16CEffectScriptManFifii",
  "control": {"kind": "condition", "values": [90]},
  "expected_matches": 1,
  "evaluate_first": true
}
```

`control` is a semantic projection: it retains the kind and integer value set,
but omits the compared expression's identity, source location, and the selected
constant's formal slot. Comparisons of different subjects against the same set
can therefore match the same row. Repeated identities receive the same policy.

Condition values are reconstructed from forward equality-controlled statement
regions, including short-circuit OR branches. Switch values group cases sharing
their actual source label. Values are normalized as a set, and duplicate or empty
sets fail validation. Every switch descriptor retains its case boundary, including
unrepresentable bounds and ranges exceeding 16 values. Such descriptors reject
reconstruction of the selected function. The default target is a separate boundary;
only forward layouts with no explicit case after the default are supported.
Nonterminal defaults and missing case/default labels fail the compilation. A
terminal default body, including explicit cases sharing that boundary, receives
no switch selector context; its target is not
claimed to be the switch join. Other unsupported condition forms leave a row
unconsumed unless its projected identity also occurs elsewhere. Neither statement
position nor compiler pointers enter a selector. The two hooks are supported
only on the hash-verified 3.0 compiler; other profiles reject these capabilities.

Centered message placement additionally distinguishes screen-limit argument 1,
512.0f for X and 480.0f for Y. Its optional `argument` uses the same fields as a
nested constant selector except for the nested callee. Argument positions refer
to the compiler's formal argument list, including an implicit receiver when one
exists; `CalcAutoPosSet` has four ordinary scalar arguments.

The optional `evaluate_before` policy names a formal sibling argument index and
requires `evaluate_first: false`. It prioritizes the selected constant in the
ordinary register-argument evaluation walk after formal slots have been assigned.
The original list order is restored before transfers to those slots. This allows
the centered-X half ratio to materialize before screen limit argument 1 while
retaining both integer values until their later floating transfers. It changes
compiler expression scheduling, without editing instructions or emitted objects.
Both the selected argument and target must still participate in this ordinary
walk: their masked argument category must be 1 or 2, their evaluated marker must
be zero, and their expression's evaluate-first flag must be false. Missing or
already evaluated siblings, other categories, self-dependencies, cycles, and incomplete restoration fail the
compilation.

Unscoped rows apply during annotation and argument consumption. Callee-scoped
rows apply at argument consumption, where a matching scoped row takes precedence
over an unscoped row regardless of configuration order. Nested selectors take
precedence over callee-only rows. Each additional nested, control, or argument
identity increases the row's specificity. All applicable rows are collected before
selection. Conflicting `(evaluate_first, evaluate_before)` policies at the greatest
specificity fail regardless of row order. Equally specific rows with the same
policy all apply; less specific consumer rows do not count as consumed there.
An unscoped row applied during annotation retains that separate consumption.
The consumer hook initializes fresh
direct constant nodes that bypassed annotation. An explicit
stable selector can adjust verified assignment wrappers and compiler-registered
literal-pool loads; arbitrary variable expressions retain normal annotation.

The adapter validates every helper, float and placement row's logical source
identity against the C/C++ files under `ps2/src` before selecting the current
unit's rows. An unknown or misspelled translation unit rejects the whole profile,
even when that row belongs to another unit. Satan's Fiddle then rejects stale
selectors within the selected compilation. Callee-scoped rows can additionally set
`expected_matches` to a positive count of distinct selected call arguments per
compiler invocation. Repeated callbacks for one call argument count once; two
formal slots or two calls count separately. The assertion never changes identity,
specificity, or selection and rejects both missing and excess matches. The five
control-context calibration rows each require one match in each mwccgap pass.
Ordinals, instruction addresses and
compiler-arena addresses are not selectors. The 3.0 profile does
not configure literal-reload behavior: the current `-O3,p` constants are immediate,
and no affected alias path has been validated for 3.0's pooled constants under
other options. The pooled-literal alias bug is established for 2.3.3.

CMake tracks the adapter, selected profile and resolved executable as compiler
dependencies. Set the two CMake cache variables explicitly when changing them
after configuration. A missing executable or profile fails with a setup message;
the build does not silently compile through plain `wibo`.

For a focused check after activation, compile one game unit and compare its
object against retail:

```sh
mkdir -p /tmp/chronicletwo-check
scripts/build/mwccgap.sh /tmp/chronicletwo-check/mg_texture.cpp.o \
  /tmp/chronicletwo-check/mg_texture.d ps2/src/mg_texture.cpp \
  -O3,p -strings readonly -c -Cpp_exceptions off -RTTI off \
  -pragma 'divbyzerocheck on' -i ps2/include
sh scripts/build/fixup_sections.sh /tmp/chronicletwo-check/mg_texture.cpp.o
python3 scripts/build/check_objects.py mg_texture --obj-dir /tmp/chronicletwo-check -v
```

Validate calibration with this full wrapper, section fixup and canonical object
checker. Objdiff percentages help locate differences but do not prove exact
bytes and resolved relocations. A corrected function can coexist with known
failures elsewhere in its unit; compare the complete failure list against the
baseline before accepting a row. See [MWCC matching notes](../../docs/MWCC.md).
Use
`python3 -m unittest discover -s scripts/build -p test_satansfiddle.py` for the
adapter's argument, selector, and failure-path checks.
Use `python3 -m unittest discover -s scripts/build -p test_objdiff_config.py`
to check template, local-symbol, and literal-name mappings.

The Docker wrapper stage also runs Satan's Fiddle's configuration and control
tests. Development images include the CLI regression runner and a separate binary
built with `hook-test-faults`; the production wrapper excludes fault injection.
A mounted genuine 3.0 compiler exercises selected and unselected calls in the same
function, all six placement schedules, two simultaneous nested saved lists,
restoration write failure without object publication, ambiguous and shadowed
policies in both row orders, excess cardinality, unsupported switch bounds,
early-evaluated targets, repeated builds, temporary filenames, stale selectors,
and implicit class-6 constructors whose raw names lack exact mangled witnesses:

```sh
export SATANSFIDDLE_TEST_COMPILER_300="$PWD/tools/compilers/mw/3.0-011126/mwccps2.exe"
export SATANSFIDDLE_TEST_EXECUTABLE=/usr/local/bin/satansfiddle
export SATANSFIDDLE_TEST_FAULT_EXECUTABLE=/usr/local/libexec/satansfiddle-tests/satansfiddle-fault-test
/usr/local/libexec/satansfiddle-tests/compiler_cli-* \
  --ignored --skip real_compilers_repeatability_float_policies_and_failure
```

The omitted legacy test additionally requires genuine MWCC 2.3.3. Nonignored
tests run in the Docker wrapper stage. Algorithm tests cover oversized/unrepresentable
case ranges, missing boundaries, nonterminal defaults, precedence and walk categories.
The stage-local native link flags also reach dependency crates so Cargo can link
all test targets; no wrapper-byte equivalence between recipes is asserted.

## Scalar placement construction conversion

The third patch, `patches/satansfiddle-placement-new.patch`, adds an optional
`placement_new.statement_conversions` table. An empty table installs no new
hooks. The capability supports only the hash-verified MWCC 3.0-011126 image.
The adapter filters rows by the logical source name for both mwccgap passes
and source-only objdiff compilation.

For example, the function-point allocation can request conversion after its
constructor has been expression-inlined:

```json
{
  "translation_unit": "funcpoint.cpp",
  "function": "Add__14CFuncPointMngrFiP9mgCMemory",
  "allocator": "__nw__FUiP1",
  "constructor": "__ct__19CList<10CFuncPoint>Fv",
  "conversion": "after_constructor_inline",
  "expected_matches": 1
}
```

All fields are mandatory. `constructor` is the exact mangled direct constructor
of the allocated scalar type. `allocator` is the exact scalar placement allocator
signature. `conversion` is `before_constructor_inline` or
`after_constructor_inline`; those timings are observably different. Before
timing supplies class 3 only for the current root constructor inline request.
After timing preserves ordinary expression inlining and requests the normal
statement-conversion worklist. Stored constructor metadata stays unchanged.

Eligibility requires a direct scalar construction whose constructor has the
measured expression-inline class 6. Class 0 and class 3 constructions are outside
this capability and are ignored uniformly, whether their link names are already
cached or still raw. Every eligible construction with the row's semantic identity
receives the same policy. `expected_matches` asserts a positive count of distinct
eligible compiler constructions;
it never selects the first, last, or numbered occurrence. Duplicate identities
and unknown fields reject the profile. Repeated observations of a construction
do not increase its match count; actual lowering must execute exactly once.

The frontend can expose a raw name before its exact link name exists. Raw stems
are provisional filters only. A changed construction must obtain exact caller,
allocator and constructor witnesses from populated compiler link-name fields
or an observational hook on the compiler's normal mangler return. A wrong
provisional overload, multiple possible rows, absent witness, unsupported
target shape, or mismatched eligible count rejects the compilation. A row with
no eligible class-6 constructions fails its count assertion.
The observed root call node, callee object and actual inline-info read must all
agree; a base/member or ordinary same-type constructor does not qualify.

The request converts the enclosing expression and can change its evaluation
and scheduling. Initial support requires exactly one scalar construction in
that region. A bounded AST walk after expression inlining finds hidden sibling
or nested constructions, and a separate observer validates actual construction
lowering. Shared construction-bearing subtrees reject. Retained inline callee
bodies are audited for deferred constructions; before timing also audits the
root constructor body. Unsupported indirect calls, body forms or cleanup
metadata reject conservatively.

Internal compiler pointers are scoped by measured arena lifetimes. An arena
reset or teardown requires completed conversion and saved exact witnesses.
Completion after process exit reads host records only. Hook, identity, scope,
count and compiler failures preserve an existing output and remove temporary
objects through the wrapper's transactional publisher.

Genuine-compiler placement tests cover both timings, selected and unselected
functions, repeated compilation, distinct same-identity constructions,
cardinality failures, temporary filenames, caller/allocator/constructor
identity errors, hidden/nested constructions, indirect inline factories,
ordinary same-type constructor calls, class-3 exclusion and stale eligibility,
and request-write failure. Run them with
the compiler and production/fault executable variables shown above:

```sh
/usr/local/libexec/satansfiddle-tests/compiler_cli-* \
  --ignored real_placement --nocapture --test-threads=1
```

An activated row requires natural C++ source, manual guard removal, resolved
complete-object checking, unchanged unrelated artifacts and PAL verification.
Zero masked instruction words alone do not establish a matching decompilation.
Rows and guard removal belong in the same buildable change because an
assembly-backed caller has zero eligible constructions and fails its assertion.

## Continuous verification

The [compiler workflow](../../.github/workflows/compiler.yml) rebuilds the
pinned toolchain and runs the genuine-compiler fixtures on pull requests,
master pushes and manual dispatches. It runs thirteen fixtures with the
production and fault-enabled executables; the legacy two-compiler fixture
is excluded because it additionally requires MWCC 2.3.3. The same workflow
runs the object/data/provenance and profile-adapter unit tests. These checks
require the tracked compiler but no retail executable or private assets.
The trusted progress workflow separately performs game-image verification
when private retail access is available.
