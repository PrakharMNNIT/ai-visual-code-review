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
  superpowers: { title: 'Superpowers', source: 'obra/superpowers', version: '6.3.0', note: 'Composable SDLC methodology skills.' },
  mattpocock: { title: 'Matt Pocock — Skills for Real Engineers', source: 'mattpocock/skills', version: '1.2.3', note: 'Engineering & productivity skills.' },
  gstack: { title: 'gstack (Garry Tan)', source: 'garrytan/gstack', version: '1.69.0.0', note: 'Role-based "virtual engineering team" skills (slimmed: Markdown only).' },
  pstack: { title: 'pstack (Lauren Tan / poteto)', source: 'michael-denyer/pstack-claude', version: '0.9.14', note: 'Rigorous agent workflow skills (Claude Code/Codex port of poteto\'s pstack).' },
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

let md = '# Agent Skills\n\n';
md += 'Vendored agent-skill packs, installed into both `.claude/skills/` (Claude Code, Cursor) ';
md += 'and `.agents/skills/` (Codex, Prime Agent). Skills are discovered automatically by ';
md += 'compatible agents via the [Agent Skills standard](https://skills.sh).\n\n';
md += '> Slimmed install: only `SKILL.md` files and their Markdown references are vendored. ';
md += 'Refresh with `./scripts/install-agent-skills.sh` then `node scripts/gen-skills-index.js`. ';
md += 'All packs are MIT licensed; each pack directory keeps its upstream `LICENSE`.\n\n';

let total = 0;
for (const pack of Object.keys(PACK_META)) {
  const dir = path.join(SKILLS_DIR, pack);
  if (!fs.existsSync(dir)) continue;
  const meta = PACK_META[pack];
  const skills = findSkills(dir);
  total += skills.length;
  md += `## ${meta.title}\n\n`;
  md += `Source: [\`${meta.source}\`](https://github.com/${meta.source}) · v${meta.version} · MIT · ${meta.note}\n\n`;
  md += '| Skill | Description |\n| --- | --- |\n';
  for (const s of skills) {
    const fm = readFrontmatter(s);
    const name = fm.name || path.basename(path.dirname(s));
    const desc = (fm.description || '').replace(/\|/g, '\\|');
    md += `| \`${name}\` | ${desc} |\n`;
  }
  md += '\n';
}

md += `---\n\n**Total: ${total} skills across ${Object.keys(PACK_META).length} packs.**\n\n`;

md += '## Recommended for this project\n\n';
md += 'This project is a Node.js/Express web app (a security-hardened visual git\n';
md += 'code-review tool). The following vendored skills map directly to its needs:\n\n';
md += '| Project need | Use these skills |\n| --- | --- |\n';
md += '| Security review (OWASP/STRIDE, injection, headers) | `gstack/cso`, `pstack/thermo-nuclear-code-quality-review`, `gstack/review` |\n';
md += '| Code review before merge | `mattpocock/code-review`, `superpowers/requesting-code-review`, `superpowers/receiving-code-review`, `pstack/make-pr-easy-to-review` |\n';
md += '| Testing (the repo uses Jest) | `superpowers/test-driven-development`, `mattpocock/tdd`, `pstack/tdd` |\n';
md += '| Debugging server/API issues | `superpowers/systematic-debugging`, `mattpocock/diagnosing-bugs`, `gstack/investigate` |\n';
md += '| Fixing CI / merge conflicts | `pstack/fix-ci`, `pstack/fix-merge-conflicts` |\n';
md += '| QA of the web UI | `gstack/qa`, `gstack/qa-only` |\n';
md += '| Planning & shipping features | `superpowers/writing-plans`, `superpowers/executing-plans`, `gstack/ship` |\n\n';
md += '### Complementary Cursor tooling (enable in the Cursor UI)\n\n';
md += '- **CodeRabbit** — deep automated code review (`code-review` skill / `code-reviewer` agent). Requires a `CODERABBIT_API_KEY` secret to run non-interactively in Cloud Agents.\n';
md += '- **Security Review** and **Bugbot** agents — on-demand security and bug review of local changes.\n';
md += '- These are Cursor plugins/agents, not filesystem skills, so they are enabled from Cursor rather than vendored here.\n';

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, md);
console.log(`Wrote ${OUT} (${total} skills).`);
