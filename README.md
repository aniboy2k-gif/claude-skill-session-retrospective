# session-retrospective

A Claude Code skill that analyzes your current session and generates a summary of lessons learned, suitable for future reference or blog post sharing.

## Installation

Copy the skill directory to your Claude Code skills folder:

```bash
cp -r session-retrospective ~/.claude/skills/
```

Or for claudecker users, place it in:
- `skills/` - baked into Docker image on build
- `.claudecker/skills/` - project-specific, loaded at container startup

## Usage

Invoke the skill with `/session-retrospective` or use natural triggers like:
- "what did we learn"
- "session summary"
- "lessons learned"
- "retro"

The skill outputs markdown to console for copy/paste.

## Output format

The retrospective includes:
- TL;DR summary
- Initial goal/problem
- The journey (challenges and how they were solved)
- Mistakes made and lessons learned
- Techniques worth remembering
- Key takeaways

## How it works

1. `scripts/get-session.sh` retrieves the current session's JSONL history
2. Claude parses messages, tool uses, and corrections
3. Identifies key moments: problems, solutions, mistakes, techniques
4. Generates blog-post-friendly markdown

## Session file format

Claude Code stores sessions as JSONL in `~/.claude/projects/<project>/<session-id>.jsonl`. Each line contains:
- `type`: "user" or "assistant"
- `message.content`: the actual content
- `timestamp`: when it occurred
- Tool results with `is_error: true` for rejected actions

## License

MIT
