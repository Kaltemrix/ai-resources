#!/bin/bash
# UserPromptSubmit hook that forces explicit skill evaluation
#
# This hook requires Claude to explicitly evaluate each specified skill
# before proceeding with implementation.
#
# Installation: Copy to ~/.claude/hooks/skill-forced-eval-hook.sh and make executable.

cat <<'EOF'
INSTRUCTION: MANDATORY SKILL ACTIVATION SEQUENCE

Step 1 - EVALUATE (do this in your response):
For each of the following skills:
- blueprint-management 
state: [skill-name] - YES/NO - [reason]

Step 2 - ACTIVATE (do this immediately after Step 1):
IF any skills are YES → Use Skill(skill-name) tool for EACH relevant skill NOW
IF no skills are YES → State "No skills needed" and proceed

Step 3 - IMPLEMENT:
Only after Step 2 is complete, proceed with implementation.

CRITICAL: You MUST call Skill() tool in Step 2. Do NOT skip to implementation.
The evaluation (Step 1) is WORTHLESS unless you ACTIVATE (Step 2) the skills.

Example of correct sequence:
- code-review: NO - not a code review task
- blueprint-management: YES - blueprint.json needs to be created
- research: YES - requires research on best practices

[Then IMMEDIATELY use Skill() tool:]
> Skill(blueprint-management)
> Skill(research)

[THEN and ONLY THEN start implementation]
EOF
