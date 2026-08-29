#!/usr/bin/env node
/**
 * gen-skills-index.js
 *
 * Scans .claude/skills/ for vendored skill packs and writes a browsable index
 * to docs/agent-skills.md. Reads the `name` and `description` fields from each
 * SKILL.md YAML frontmatter.
 */
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const SKILLS_DIR = path.join(ROOT, '.claude', 'skills');
const OUT = path.join(ROOT, 'docs', 'agent-skills.md');

const PACK_META = {
  superpowers: {
    title: 'Superpowers',
    source: 'obra/superpowers',
    version: '6.3.0',
    note: 'Composable SDLC methodology skills.'
  },
  mattpocock: {
    title: 'Matt Pocock — Skills for Real Engineers',
    source: 'mattpocock/skills',
    version: '1.2.3',
    note: 'Engineering and productivity skills.'
  },
  gstack: {
    title: 'gstack (Garry Tan)',
    source: 'garrytan/gstack',
    version: '1.72.0.0',
    note: 'Role-based virtual engineering team skills (slimmed: Markdown plus skill scripts).'
  },
  pstack: {
    title: 'pstack (Lauren Tan / poteto)',
    source: 'cursor/plugins',
    tree: 'pstack',
    version: '0.14.5',
    note: 'Official Cursor pstack. Rigorous agent workflow skills.'
  },
  improve: {
    title: 'improve (shadcn)',
    source: 'shadcn/improve',
    version: '03369ee',
    note: 'Audits a codebase and writes execution plans. Does not implement the plans itself.'
  },
  'cursor-team-kit': {
    title: 'Cursor Team Kit',
    source: 'cursor/plugins',
    tree: 'cursor-team-kit',
    version: '1.2.0',
    note: 'Cursor internal CI, review, shipping, and verification workflows.'
  },
  'vercel-agent-skills': {
    title: 'Vercel Agent Skills',
    source: 'vercel-labs/agent-skills',
    version: '063bee9',
    note: 'Official Vercel web, React, writing, and deploy skills.'
  },
  addyosmani: {
    title: 'Addy Osmani — Agent Skills',
    source: 'addyosmani/agent-skills',
    version: '0.6.8',
    note: 'Production engineering skills across spec, build, test, review, and ship.'
  },
  'find-skills': {
    title: 'find-skills (Vercel Labs)',
    source: 'vercel-labs/skills',
    version: '1.5.23',
    note: 'Skill #0 / discovery. On-demand lookup, not an always-on personality.'
  },
  trailofbits: {
    title: 'Trail of Bits',
    source: 'trailofbits/skills',
    version: 'd1f1575',
    note: 'Security research, review, and audit skills. Discover on demand; do not always-apply every skill.'
  },
  'agent-browser': {
    title: 'agent-browser',
    source: 'vercel-labs/agent-browser',
    version: '0.35.1',
    note: 'Browser automation CLI skill for agents. Pair with the optional agent-browser binary.'
  },
  'compound-engineering': {
    title: 'Compound Engineering',
    source: 'EveryInc/compound-engineering-plugin',
    version: '2.42.0',
    note: 'Learn/compound layer. Do not run CE with gstack, Superpowers, and pstack on the same task.'
  },
  anthropics: {
    title: 'Anthropic example skills (subset)',
    source: 'anthropics/skills',
    version: '3b3fad9',
    note: 'frontend-design, webapp-testing, mcp-builder, skill-creator, claude-api only. No pptx/xlsx/docx/art/branding/gifs.'
  },
  'awesome-copilot': {
    title: 'Awesome Copilot (GitHub workflow subset)',
    source: 'github/awesome-copilot',
    version: 'f11a4e4',
    note: 'Issue, PR, Actions, and gh workflow skills only. Upstream is 400+ skills; this repo vendors a documented subset.'
  }
};

function readFrontmatter(file) {
  const text = fs.readFileSync(file, 'utf8');
  if (!text.startsWith('---')) return {};
  const end = text.indexOf('\n---', 3);
  if (end === -1) return {};
  const fm = text.slice(3, end);
  const out = {};
  for (const line of fm.split('\n')) {
    const m = line.match(/^(name|description):\s*(.*)$/);
    if (m) out[m[1]] = m[2].replace(/^["']|["']$/g, '').trim();
  }
  return out;
}

function findSkills(packDir) {
  const results = [];
  (function walk(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, entry.name);
      if (entry.isDirectory()) walk(p);
      else if (entry.name === 'SKILL.md') results.push(p);
    }
  })(packDir);
  return results.sort();
}

function sourceLink(meta) {
  const href = meta.tree
    ? `https://github.com/${meta.source}/tree/main/${meta.tree}`
    : `https://github.com/${meta.source}`;
  const label = meta.tree ? `${meta.source}/${meta.tree}` : meta.source;
  return `[\`${label}\`](${href})`;
}

let md = '# Agent Skills\n\n';
md += 'Vendored agent-skill packs, installed into both `.claude/skills/` (Claude Code, Cursor) ';
md += 'and `.agents/skills/` (Codex, Prime Agent). Skills are discovered automatically by ';
md += 'compatible agents via the [Agent Skills standard](https://agentskills.io).\n\n';
md += '> Slimmed install: `SKILL.md`, Markdown references, and each skill\'s `scripts/` directory. ';
md += 'Refresh with `./scripts/install-agent-skills.sh` then `node scripts/gen-skills-index.js`. ';
md += 'Packs keep their upstream LICENSE when the clone has one. Why these packs, and which ';
md += 'ones were skipped: [`docs/agent-skill-packs.md`](agent-skill-packs.md).\n\n';

let total = 0;
let present = 0;
for (const pack of Object.keys(PACK_META)) {
  const dir = path.join(SKILLS_DIR, pack);
  if (!fs.existsSync(dir)) continue;
  present += 1;
  const meta = PACK_META[pack];
  const skills = findSkills(dir);
  total += skills.length;
  md += `## ${meta.title}\n\n`;
  md += `Source: ${sourceLink(meta)} · v${meta.version} · ${meta.note}\n\n`;
  md += '| Skill | Description |\n| --- | --- |\n';
  for (const s of skills) {
    const fm = readFrontmatter(s);
    const name = fm.name || path.basename(path.dirname(s));
    const desc = (fm.description || '').replace(/\|/g, '\\|');
    md += `| \`${name}\` | ${desc} |\n`;
  }
  md += '\n';
}

md += `---\n\n**Total: ${total} skills across ${present} packs.**\n\n`;

md += '## Recommended for this project\n\n';
md += 'This project is a Node.js/Express web app (a security-hardened visual git\n';
md += 'code-review tool). The following vendored skills map directly to its needs:\n\n';
md += '| Project need | Use these skills |\n| --- | --- |\n';
md += '| Discover which skill applies | `find-skills/find-skills` |\n';
md += '| Full-repo audit and execution plans | `improve/improve` |\n';
md += '| Security review (on demand) | `trailofbits/*`, `gstack/cso`, `addyosmani/security-and-hardening` |\n';
md += '| Code review before merge | `mattpocock/code-review`, `addyosmani/code-review-and-quality`, `superpowers/requesting-code-review`, `cursor-team-kit/make-pr-easy-to-review` |\n';
md += '| Testing (the repo uses Jest) | `superpowers/test-driven-development`, `mattpocock/tdd`, `addyosmani/test-driven-development` |\n';
md += '| Debugging server/API issues | `superpowers/systematic-debugging`, `mattpocock/diagnosing-bugs`, `gstack/investigate` |\n';
md += '| Fixing CI / merge conflicts | `cursor-team-kit/fix-ci`, `cursor-team-kit/fix-merge-conflicts`, `cursor-team-kit/loop-on-ci` |\n';
md += '| QA of the web UI | `agent-browser/agent-browser`, `gstack/qa`, `anthropics/webapp-testing` |\n';
md += '| Planning and shipping | `superpowers/writing-plans`, `superpowers/executing-plans`, `gstack/ship`, `addyosmani/shipping-and-launch` |\n';
md += '| UI craft | `anthropics/frontend-design`, `vercel-agent-skills/web-design-guidelines` |\n';
md += '| GitHub issues / PRs | `awesome-copilot/github-issues`, `mattpocock/triage` |\n';
md += '| Compound after ship | `compound-engineering/ce-compound` (not on the same task as gstack, Superpowers, or pstack) |\n\n';
md += 'Pick **one** spec/implement methodology per task. Do not run gstack, Superpowers, pstack, and Compound Engineering together.\n\n';
md += '### Complementary Cursor tooling (enable in the Cursor UI)\n\n';
md += '- **CodeRabbit** — deep automated code review (`code-review` skill / `code-reviewer` agent). Requires a `CODERABBIT_API_KEY` secret to run non-interactively in Cloud Agents.\n';
md += '- **Security Review** and **Bugbot** agents — on-demand security and bug review of local changes.\n';
md += '- These are Cursor plugins/agents, not filesystem skills, so they are enabled from Cursor rather than vendored here.\n';

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, md);
console.log(`Wrote ${OUT} (${total} skills).`);
