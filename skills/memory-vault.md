---
name: memory-vault
description: >
  Retrieve and maintain the user's durable external memory when a
  request may depend on previous work, existing projects, stored
  notes, prior decisions, saved context, or when they ask to read,
  search, check, or update their notes, vault, or memory.
---

# Memory Vault

Use the user's durable external Memory Vault when stored context may
materially improve or determine the response.

## Storage access

The storage mechanism is not fixed to one platform or path — it varies
per installation. Determine it from whatever the current environment
already exposes (a connected vault/notes tool, a device-bridge folder,
or similar), rather than assuming a fixed location. If it isn't
already established this session, ask the user where their vault is
stored, whether read/write access is wanted, and which mechanism they
prefer — do not guess or fabricate a path. Prefer direct local
filesystem or connector access when available. Never claim to have
accessed memory if storage access was unavailable.

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

Read automatically when retrieval triggers apply. Write durable memory
conservatively — this is not a transcript, reasoning log, or automatic
changelog. Canonical files hold the best current state; when
information changes, replace the obsolete text rather than narrating
its history, unless that history itself has durable value (then it
belongs in `DECISIONS.md`).

## Maintenance

Perform safe, unambiguous index and structural repairs automatically.
Tell the user when retrieval may be incomplete, storage access fails,
reading or writing fails, expected memory is missing, information
conflicts with no clear canonical version, an index or state file
needs real restructuring, a new routing layer is advisable, sync
conflicts or possible data loss appear, or anything else could reduce
future memory reliability. Do not report routine maintenance.