const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const PACKS = [
  'superpowers',
  'mattpocock',
  'gstack',
  'pstack',
  'improve',
  'cursor-team-kit',
  'vercel-agent-skills',
  'addyosmani',
  'find-skills',
  'trailofbits',
  'agent-browser',
  'compound-engineering',
  'anthropics',
  'awesome-copilot'
];

const PSTACK_SLUGS = new Set([
  'inherit-parent',
  'auto',
  'claude-fable-5-thinking-high',
  'claude-fable-5-thinking-xhigh',
  'claude-opus-5-thinking-high',
  'claude-opus-5-thinking-high-fast',
  'claude-sonnet-5-thinking-high',
  'claude-sonnet-5-thinking-xhigh',
  'composer-2.5',
  'composer-2.5-fast',
  'cursor-grok-4.5-high',
  'cursor-grok-4.5-high-fast',
  'cursor-grok-4.6-high-fast',
  'gemini-3.7-flash-high',
  'gpt-5.6-luna-high',
  'gpt-5.6-sol-high',
  'gpt-5.6-sol-high-fast',
  'gpt-5.6-sol-xhigh',
  'gpt-5.6-sol-xhigh-fast'
]);

describe('vendored agent skill packs', () => {
  test.each(PACKS)('%s is present under .claude/skills and .agents/skills with a SKILL.md', (pack) => {
    for (const root of ['.claude/skills', '.agents/skills']) {
      const dir = path.join(ROOT, root, pack);
      expect(fs.existsSync(dir)).toBe(true);
      const skill = findSkill(dir);
      expect(skill).not.toBeNull();
    }
  });

  test('improve ships the audit playbook and plan template', () => {
    const refs = path.join(ROOT, '.claude/skills/improve/improve/references');
    expect(fs.existsSync(path.join(refs, 'audit-playbook.md'))).toBe(true);
    expect(fs.existsSync(path.join(refs, 'plan-template.md'))).toBe(true);
    expect(fs.existsSync(path.join(refs, 'closing-the-loop.md'))).toBe(true);
  });

  test('docs/agent-skills.md lists every pack', () => {
    const index = fs.readFileSync(path.join(ROOT, 'docs/agent-skills.md'), 'utf8');
    for (const pack of [
      'Superpowers',
      'improve (shadcn)',
      'Cursor Team Kit',
      'Vercel Agent Skills',
      'Addy Osmani',
      'find-skills (Vercel Labs)',
      'Trail of Bits',
      'agent-browser',
      'Compound Engineering',
      'Anthropic example skills',
      'Awesome Copilot'
    ]) {
      expect(index).toContain(pack);
    }
  });

  test('find-skills vendors only the discovery skill', () => {
    const dir = path.join(ROOT, '.claude/skills/find-skills');
    expect(fs.existsSync(path.join(dir, 'find-skills', 'SKILL.md'))).toBe(true);
    expect(countSkills(dir)).toBe(1);
  });

  test('anthropics subset excludes document and art skills', () => {
    const dir = path.join(ROOT, '.claude/skills/anthropics');
    const names = skillDirNames(dir);
    expect(names.sort()).toEqual([
      'claude-api',
      'frontend-design',
      'mcp-builder',
      'skill-creator',
      'webapp-testing'
    ]);
    for (const skipped of ['pptx', 'xlsx', 'docx', 'algorithmic-art', 'brand-guidelines', 'slack-gif-creator']) {
      expect(names).not.toContain(skipped);
    }
  });

  test('awesome-copilot is a GitHub workflow subset, not the full catalog', () => {
    const dir = path.join(ROOT, '.claude/skills/awesome-copilot');
    const names = skillDirNames(dir);
    expect(names).toContain('github-issues');
    expect(names).toContain('gh-attach');
    expect(names).toContain('copilot-pr-autopilot');
    expect(names).not.toContain('adobe-illustrator-scripting');
    expect(names.length).toBeLessThan(40);
    expect(names.length).toBeGreaterThan(10);
  });
});

describe('skill pack policy and setup docs', () => {
  test('spec-kit is documented, not vendored as a skill pack', () => {
    expect(fs.existsSync(path.join(ROOT, '.claude/skills/spec-kit'))).toBe(false);
    const packs = fs.readFileSync(path.join(ROOT, 'docs/agent-skill-packs.md'), 'utf8');
    expect(packs).toContain('specify init --here --integration cursor-agent');
    expect(packs).toContain('find-skills → spec');
    expect(packs).toContain('microsoft/skills');
    expect(packs).toContain('aws/agent-toolkit-for-aws');
    expect(packs).toContain('cloudflare/skills');
    expect(packs).toContain('supabase/agent-skills');
  });

  test('matt pocock setup records GitHub issues, default labels, and single-context docs', () => {
    const tracker = fs.readFileSync(path.join(ROOT, 'docs/agents/issue-tracker.md'), 'utf8');
    const labels = fs.readFileSync(path.join(ROOT, 'docs/agents/triage-labels.md'), 'utf8');
    const domain = fs.readFileSync(path.join(ROOT, 'docs/agents/domain.md'), 'utf8');
    expect(tracker).toContain('praxstack/ai-visual-code-review');
    expect(tracker).toMatch(/PRs as a request surface:\s*no/i);
    expect(labels).toContain('ready-for-agent');
    expect(domain).toContain('single-context');
  });

  test('pstack-models.mdc uses only detected Cursor Task slugs', () => {
    const file = path.join(ROOT, '.cursor/rules/pstack-models.mdc');
    expect(fs.existsSync(file)).toBe(true);
    const text = fs.readFileSync(file, 'utf8');
    expect(text).toContain('alwaysApply: true');
    const unknown = [];
    for (const line of text.split('\n')) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#') || trimmed.startsWith('---')) continue;
      if (trimmed.startsWith('description:') || trimmed.startsWith('alwaysApply:')) continue;
      const colon = trimmed.indexOf(':');
      if (colon === -1) continue;
      const rhs = trimmed.slice(colon + 1);
      for (const slug of rhs.split(',').map((s) => s.trim()).filter(Boolean)) {
        if (!PSTACK_SLUGS.has(slug)) unknown.push(slug);
      }
    }
    expect(unknown).toEqual([]);
  });
});

function findSkill(dir) {
  const stack = [dir];
  while (stack.length) {
    const current = stack.pop();
    for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
      const p = path.join(current, entry.name);
      if (entry.isDirectory()) stack.push(p);
      else if (entry.name === 'SKILL.md') return p;
    }
  }
  return null;
}

function countSkills(dir) {
  let n = 0;
  const stack = [dir];
  while (stack.length) {
    const current = stack.pop();
    for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
      const p = path.join(current, entry.name);
      if (entry.isDirectory()) stack.push(p);
      else if (entry.name === 'SKILL.md') n += 1;
    }
  }
  return n;
}

function skillDirNames(dir) {
  return fs.readdirSync(dir, { withFileTypes: true })
    .filter((e) => e.isDirectory() && fs.existsSync(path.join(dir, e.name, 'SKILL.md')))
    .map((e) => e.name);
}
