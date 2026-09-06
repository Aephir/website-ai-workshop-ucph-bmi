---
name: memory-vault
description: "Retrieve and maintain the user's durable external memory when a request may depend on previous work, existing projects, stored notes, prior decisions, saved context, or when they ask to read, search, check, or update their notes, vault, or memory."
---

# Memory Vault

Use the user's durable external Memory Vault when stored context may
materially improve or determine the response.

## Storage access

Before asking, assume the vault is a folder named "Memory Vault" (or
close to it) directly inside this project's root folder, and check
there first. Confirm it by the presence of `00_SYSTEM/START_HERE.md`
— not by name alone, since a same-named folder without that marker is
not the vault. If found, use it directly.

If nothing matching is found at the project root, do not guess further
or fabricate a path. The vault may not be a plain folder at all in
this environment — it could be an Obsidian vault, network storage
reached through a connector, or something else entirely. Ask the user
where their vault is stored, whether read/write access is wanted, and
which mechanism they prefer.

Do not infer that a tool or connector is the Memory Vault merely
because its name contains "vault," "memory," or similar — more than
one similarly-named storage location can exist for different, narrower
purposes (e.g. a notes app kept only for a specific cross-platform
sync need unrelated to general project memory). When project or
session instructions identify a specific location as the Memory Vault
(a path, a connected folder, a named tool), use that one over any
name-matching guess or the project-root default above.

Once a location is confirmed — by finding it at the project root or by
asking — that fact belongs to this particular project or environment,
not to how the vault works in general. Record it by telling the user
and suggesting they add it to this project's own instructions, so
future sessions here skip the search. Do not rewrite this skill file
with a discovered path: a path (or storage mechanism) hardcoded here
would be wrong for every other project or person using the same skill,
defeating the reason it's written generically in the first place.

## Invoke this skill when

- a request relates to previous or ongoing work;
- an existing project or topic may have stored context;
- previous decisions may matter;
- the user asks what was previously decided or known;
- they say continue, resume, revisit, or pick up earlier work;
- they ask to read, search, check, or update their notes, the vault,
  or memory;
- equivalent wording indicates stored context should be used.

Do not invoke for clearly self-contained requests where stored context
is irrelevant.

## Retrieval

1. Access the vault through the configured storage mechanism.
2. Read `00_SYSTEM/START_HERE.md` if not already established this
   session.
3. Route from `00_SYSTEM/ROOT_INDEX.md` through hierarchical
   `INDEX.md` files toward the relevant topic.
4. Load only the minimum relevant state, decisions, notes, or
   documents.
5. Prefer targeted search when index routing is insufficient.
6. Do not recursively read the entire vault merely to establish
   context.
7. Stop once there is enough reliable context for the task.

## Writing

Retrieval and writing share the same trigger conditions, but writing
splits into two separate paths kept physically apart, so an automatic
write can never corrupt canonical state.

**Canonical files** — STATE.md, DECISIONS.md, index/routing files, and
any note that represents the current truth of a project or topic — are
confirm-gated. Update one only when a decision, status change, or
correction is clear enough that it was effectively confirmed in the
same conversation (discussed with the user directly, not inferred).
When replacing obsolete text, drop the old version rather than
narrating the change — history goes to DECISIONS.md only when the
history itself has durable value. Never silently overwrite a canonical
file on an inference the user hasn't actually confirmed.

**A running log** — additive only, never overwritten — absorbs
everything worth keeping that isn't yet decision-grade: a correction
that might recur, an observation a future collaborator or session would
need, a fact worth not re-deriving next time. Write here automatically,
without asking, but only when one of these concrete triggers fires —
never on a general sense that something seems "important":

- the same correction or clarification has been given more than once;
- a mistake occurred that a future session should not repeat;
- something was learned that a new collaborator would need in order to
  be productive on this topic;
- a decision or status change happened but isn't yet confirmed as
  canonical.

Use the vault's existing per-topic conventions to place this (e.g. a
log or notes file alongside a project's other notes); create one on
demand if none exists rather than inventing a new top-level structure.
Keep entries terse, one line where possible. Skip logging anything
already derivable from the source material, and anything a canonical
file already states.

## Maintenance

Perform safe, unambiguous index and structural repairs automatically.
When a running log grows past a reasonable size, fold entries that have
proven durable into the relevant canonical file and prune the rest,
rather than letting it grow indefinitely.

Tell the user when retrieval may be incomplete, storage access fails,
reading or writing fails, expected memory is missing, information
conflicts with no clear canonical version, an index or state file
needs real restructuring, a new routing layer is advisable, sync
conflicts or possible data loss appear, or anything else could reduce
future memory reliability. Do not report routine maintenance.