# GovTech Trend Radar

A self-scheduling AI agent that researches low-code/no-code platform trends and AI features in government software, and posts a digest to Slack — every day, automatically.

Built with [Claude Code](https://claude.com/claude-code) as a training project for AI Product Management.

## What it does

Government software vendors in the eJustice, Social Protection, Public Finance Management, and Monitoring & Evaluation space are moving fast on two fronts: which low-code platforms they build on, and how fast AI features are showing up inside that software. This agent tracks both, daily, so no one has to check manually.

## How it works

1. **Wake** — a cron job fires daily at noon, local time. If the machine is asleep, that run is simply skipped — no catch-up queue, by design.
2. **Recall** — reads its own history log (`reported-history.md`) to see what's already been reported, so the digest never repeats a story.
3. **Search** — scans govtech vendor news, AI-feature launches, analyst commentary, and donor/development-bank sources (World Bank, UN, ADB, EU) across all four verticals.
4. **Filter** — drops anything stale, generic, or already seen; keeps only what's genuinely new.
5. **Report** — composes a short digest and posts it to a Slack channel via webhook.
6. **Remember** — logs what it reported and how the run went (`execution-log.md`), then commits and pushes both files back to this repo.

## Project structure

| File | Purpose |
|---|---|
| `run-trend-agent.sh` | Cron entry point — loads local secrets, runs the agent headlessly, syncs results to GitHub |
| `trend-agent-prompt.txt` | The full task instructions given to the agent on every run |
| `reported-history.md` | Running log of everything reported so far (auto-generated) |
| `execution-log.md` | Per-run log for troubleshooting: what was searched, what was found, outcome (auto-generated) |

Two things intentionally **don't** live in this repo: the Slack webhook URL and the auth token used to run the agent headlessly — both are kept in local, gitignored files.

## Stack

Claude Code (headless `-p` mode) · `cron` · Slack incoming webhook · a dedicated, write-scoped GitHub deploy key for the auto-push step.
