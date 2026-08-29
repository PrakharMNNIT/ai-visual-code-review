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
  'awesome-copilot',
  'spec-kit',
  'microsoft',
  'aws',
  'cloudflare',
  'supabase'
];

const MICROSOFT_SUBSET = [
  'cloud-solution-architect',
  'continual-learning',
  'copilot-sdk',
  'frontend-design-review',
  'github-issue-creator',
  'mcp-builder',
  'microsoft-docs',
  'skill-creator',
  'wiki-agents-md',
  'wiki-architect',
  'wiki-changelog',
  'wiki-llms-txt',
  'wiki-onboarding',
  'wiki-page-writer',
  'wiki-qa',
  'wiki-researcher'
];

const SPECKIT_COMMANDS = [
  'constitution',
  'specify',
  'plan',
  'tasks',
  'implement'
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
      'Awesome Copilot',
      'GitHub Spec Kit',
      'Microsoft skills',
      'AWS agent toolkit',
      'Cloudflare skills',
      'Supabase agent skills'
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

  test('awesome-copilot is the full toolbox shelf, not a 15-skill subset', () => {
    const dir = path.join(ROOT, '.claude/skills/awesome-copilot');
    const n = countSkills(dir);
    expect(n).toBeGreaterThan(200);
    expect(n).toBeLessThan(2000);
    const names = skillDirNames(dir);
    expect(names).toContain('github-issues');
    expect(names).toContain('adobe-illustrator-scripting');
  });
});

describe('spec-kit, microsoft subset, and stack packs', () => {
  test('spec-kit is vendored as command skills without specify-init in app source', () => {
    const dir = path.join(ROOT, '.claude/skills/spec-kit');
    expect(fs.existsSync(dir)).toBe(true);
    for (const cmd of SPECKIT_COMMANDS) {
      expect(fs.existsSync(path.join(dir, cmd, 'SKILL.md'))).toBe(true);
    }
    expect(countSkills(dir)).toBeGreaterThanOrEqual(5);
    expect(fs.existsSync(path.join(ROOT, '.specify'))).toBe(false);
    const packs = fs.readFileSync(path.join(ROOT, 'docs/agent-skill-packs.md'), 'utf8');
    expect(packs).toContain('specify init --here --integration cursor-agent');
    expect(packs).toContain('git+https://github.com/github/spec-kit.git@v1.0.1');
    expect(packs).toContain('find-skills → spec');
  });

  test('microsoft is a documented subset, not the whole catalog', () => {
    const dir = path.join(ROOT, '.claude/skills/microsoft');
    const names = skillDirNames(dir).sort();
    expect(names).toEqual([...MICROSOFT_SUBSET].sort());
    expect(names.length).toBeGreaterThan(10);
    expect(names.length).toBeLessThan(40);
    expect(names).not.toContain('azure-cosmos-py');
    expect(names).not.toContain('podcast-generation');
    const installer = fs.readFileSync(path.join(ROOT, 'scripts/install-agent-skills.sh'), 'utf8');
    const packsDoc = fs.readFileSync(path.join(ROOT, 'docs/agent-skill-packs.md'), 'utf8');
    expect(installer).toContain('MICROSOFT_SKILLS=');
    for (const name of MICROSOFT_SUBSET) {
      expect(installer).toContain(name);
      expect(packsDoc).toContain(name);
    }
  });

  test('aws, cloudflare, and supabase packs are present', () => {
    const aws = countSkills(path.join(ROOT, '.claude/skills/aws'));
    const cf = countSkills(path.join(ROOT, '.claude/skills/cloudflare'));
    const sb = countSkills(path.join(ROOT, '.claude/skills/supabase'));
    expect(aws).toBeGreaterThan(20);
    expect(cf).toBeGreaterThan(5);
    expect(sb).toBeGreaterThanOrEqual(2);
    expect(fs.existsSync(path.join(ROOT, '.agents/skills/aws'))).toBe(true);
    expect(fs.existsSync(path.join(ROOT, '.agents/skills/cloudflare'))).toBe(true);
    expect(fs.existsSync(path.join(ROOT, '.agents/skills/supabase'))).toBe(true);
  });

  test('awesome-copilot is much larger than the microsoft subset', () => {
    const awesome = countSkills(path.join(ROOT, '.claude/skills/awesome-copilot'));
    const ms = countSkills(path.join(ROOT, '.claude/skills/microsoft'));
    expect(awesome).toBeGreaterThan(ms * 5);
  });
});

describe('skill pack policy and setup docs', () => {
  test('pipeline docs keep XOR methodology and stack sources', () => {
    const packs = fs.readFileSync(path.join(ROOT, 'docs/agent-skill-packs.md'), 'utf8');
    expect(packs).toContain('microsoft/skills');
    expect(packs).toContain('aws/agent-toolkit-for-aws');
    expect(packs).toContain('cloudflare/skills');
    expect(packs).toContain('supabase/agent-skills');
    expect(packs).toContain('Never run Compound Engineering, gstack, Superpowers, and pstack');
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
    expect(unknownPstackSlugs(text)).toEqual([]);
  });
});

function unknownPstackSlugs(text) {
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
  return unknown;
}

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
