const { spawnSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');

const REPO_ROOT = path.resolve(__dirname, '..');
const SCRIPT = path.join(REPO_ROOT, 'scripts', 'link-agent-skills.sh');
const SHEET = path.join(REPO_ROOT, '.cursor', 'pstack-models.md');
const INCLUDE_LINE = '@~/.claude/pstack-models.md';

const REQUIRED_ROLES = [
  'feature, refactoring',
  'bug-fix',
  'perf-issue',
  'hillclimb',
  'judgment and prose',
  'strongest judgment',
  'how explorer',
  'how explainer',
  'how critics',
  'why investigators',
  'why synthesizer',
  'reflect tooling',
  'reflect judgment, divergent, synthesizer',
  'arena runners',
  'arena cross-judge pool',
  'swarm workers',
  'architect runners',
  'interrogate reviewers'
];

const CURSOR_TASK_SLUGS = new Set([
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

const SLUG = /^[a-z0-9][a-z0-9.-]*$/;

function parseRoleLines(markdown) {
  const roles = new Map();
  for (const line of markdown.split('\n')) {
    if (!line || line.startsWith('#') || !line.includes(':')) {
      continue;
    }
    const idx = line.indexOf(':');
    const role = line.slice(0, idx).trim();
    const models = line.slice(idx + 1).split(',').map((s) => s.trim()).filter(Boolean);
    if (!role || !models.length || !models.every((slug) => SLUG.test(slug))) {
      continue;
    }
    roles.set(role, models);
  }
  return roles;
}

function runLink(homeDir, envExtra = {}) {
  return spawnSync('bash', [SCRIPT], {
    encoding: 'utf8',
    env: { ...process.env, HOME: homeDir, ...envExtra }
  });
}

describe('pstack model sheet', () => {
  test('every role uses a confirmed Cursor Task slug', () => {
    const markdown = fs.readFileSync(SHEET, 'utf8');
    const roles = parseRoleLines(markdown);

    for (const role of REQUIRED_ROLES) {
      expect(roles.has(role)).toBe(true);
    }

    for (const models of roles.values()) {
      for (const slug of models) {
        expect(CURSOR_TASK_SLUGS.has(slug)).toBe(true);
      }
    }
  });
});

describe('link-agent-skills.sh pstack models', () => {
  let tmpHome;

  beforeEach(() => {
    tmpHome = fs.mkdtempSync(path.join(os.tmpdir(), 'pstack-models-'));
  });

  afterEach(() => {
    fs.rmSync(tmpHome, { recursive: true, force: true });
  });

  test('copies the sheet and wires CLAUDE.md when CURSOR_AGENT=1', () => {
    const result = runLink(tmpHome, { CURSOR_AGENT: '1' });
    expect(result.status).toBe(0);

    const dest = path.join(tmpHome, '.claude', 'pstack-models.md');
    const claudeMd = path.join(tmpHome, '.claude', 'CLAUDE.md');
    expect(fs.readFileSync(dest, 'utf8')).toBe(fs.readFileSync(SHEET, 'utf8'));
    expect(fs.readFileSync(claudeMd, 'utf8').trim()).toBe(INCLUDE_LINE);
  });

  test('appends the include once when CLAUDE.md already has other text', () => {
    const claudeDir = path.join(tmpHome, '.claude');
    fs.mkdirSync(claudeDir, { recursive: true });
    const claudeMd = path.join(claudeDir, 'CLAUDE.md');
    fs.writeFileSync(claudeMd, '# existing rules\n');

    expect(runLink(tmpHome, { CURSOR_AGENT: '1' }).status).toBe(0);
    expect(runLink(tmpHome, { CURSOR_AGENT: '1' }).status).toBe(0);

    const body = fs.readFileSync(claudeMd, 'utf8');
    expect(body.startsWith('# existing rules')).toBe(true);
    expect(body.split(INCLUDE_LINE).length - 1).toBe(1);
  });

  test('leaves home pstack-models untouched when CURSOR_AGENT is unset', () => {
    const result = runLink(tmpHome, { CURSOR_AGENT: '' });
    expect(result.status).toBe(0);
    expect(fs.existsSync(path.join(tmpHome, '.claude', 'pstack-models.md'))).toBe(false);
  });
});
