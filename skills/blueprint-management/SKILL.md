---
name: blueprint-management
description: >
  Governs how and when blueprint.json is created, read, and updated throughout
  a session. USE THIS SKILL: at the very start of every session; before starting
  any task; when a task is created, updated, or completed; when blockers are
  encountered or resolved. This skill is non-negotiable and must be applied
  continuously throughout the session.
---

# Blueprint Management Skill

## What is blueprint.json?

`blueprint.json` lives at `.planning/blueprint.json` inside the working
directory. It is the single source of truth for all in-progress, planned, and
completed work in the session. It is derived from `assets/blueprint-example.json`
(relative to this skill's directory), which serves as the canonical template.

---

## Session Start (required before anything else)

1. Check whether `.planning/blueprint.json` exists.
2. If it does **not** exist, run the init script:
   ```bash
   bash ${CLAUDE_SKILL_DIR}/scripts/new_blueprint.sh "$PWD" "${CLAUDE_SKILL_DIR}"
   ```
   This copies `${CLAUDE_SKILL_DIR}/assets/blueprint-example.json` to
   `.planning/blueprint.json` in the current working directory.
   Do not do anything else first.
3. Read `.planning/blueprint.json` in full.
4. Only after completing steps 1-3 are you permitted to proceed with any work.

---

## Before Starting Work on a New Request

1. Understand the full scope of what is being asked.
2. Break the work into discrete, actionable tasks.
3. Add every task to `blueprint.json` under the `tasks` array before writing a
   single line of code or making any changes.
4. Each task must follow the structure in `example_task` (see below).
5. Set `status_section.current_state` to `in-progress`.
6. Do not include estimates, priorities, or effort levels of any kind.

---

## Task Structure

Every task must conform to the structure defined in the `example_task` field of
`blueprint-example.json`:

```json
{
  "id": "UNIQUE_ID",
  "phase": "Phase Name",
  "title": "Short task title",
  "description": "What this task does",
  "status": "not-started",
  "blockers": ["ID of any tasks that must complete first"],
  "completion_notes": "",
  "sub_tasks": [
    {
      "id": "UNIQUE_SUBTASK_ID",
      "title": "Short subtask title",
      "description": "What this subtask does",
      "status": "not-started",
      "blockers": [],
      "completion_notes": ""
    }
  ]
}
```

Valid values for `status`: `not-started`, `in-progress`, `completed`.

---

## During Work - Continuous Updates

Update `blueprint.json` every time any of the following happen:

| Event | Required update |
|---|---|
| You begin a task | Set its `status` to `in-progress` |
| You complete a task | Set its `status` to `completed`, fill `completion_notes` |
| A subtask begins | Set its `status` to `in-progress` |
| A subtask completes | Set its `status` to `completed`, fill `completion_notes` |
| A blocker is encountered | Record it in the relevant task's `blockers` array and in `status_section.notes` |
| A blocker is resolved | Update the note and remove the blocker ID |
| You deviate from the plan | Record the deviation in `status_section.architectural_deviations` |
| A phase review is completed | Add an entry to `status_section.phase_reviews` |
| All tasks complete | Set `status_section.current_state` to `completed` |

Blueprint updates are not optional. They must happen immediately when the
triggering event occurs, not batched at the end.

---

## Rules You Must Not Break

- Never edit or remove sections of `blueprint.json` you did not create. This
  includes `project_title`, `global_alerts`, `mandatory_directives`, and any
  tasks belonging to other agents or sessions.
- Never add estimates, priorities, or effort levels to any task or subtask.
- The task list must be exhaustive. If you discover additional work mid-session,
  add it to the blueprint before doing it.
- Do not stop working until `status_section.current_state` is `completed` and
  every task has a `status` of `completed`.
- `blueprint.json` must always reflect reality. If the code changes, the
  blueprint changes. If the plan changes, the blueprint changes.

---

## Scope of This Skill

This skill must be invoked:

- At the start of every session, without exception.
- Before any new work begins.
- When any task is created, updated to `in-progress`, or updated to `completed`.
- When any subtask is created, updated to `in-progress`, or updated to `completed`.
- When blockers are added or removed.
- When deviations from the plan occur.
- Before committing any code.

The only time this skill is not actively being applied is when you are in the
middle of executing a task. As soon as that task reaches any boundary (start,
completion, blocker), return here.

---

## Supporting files

- [`assets/blueprint-example.json`](assets/blueprint-example.json) — The
  canonical template that `new_blueprint.sh` copies into a project. Load this
  when you need the exact schema or field names for tasks, sub-tasks, or the
  status section.
- [`scripts/new_blueprint.sh`](scripts/new_blueprint.sh) — Initializes
  `.planning/blueprint.json` from the template. Pass the project root as the
  first argument. Creates `.planning/` if it does not already exist.
