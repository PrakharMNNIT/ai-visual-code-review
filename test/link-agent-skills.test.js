const { execFileSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const SCRIPT = path.join(ROOT, 'scripts/link-agent-skills.sh');
const PACK = path.join(ROOT, '.claude/skills/gstack');
const PROJECT_SKILLS = path.join(ROOT, '.cursor/skills');

function runLink(home) {
  execFileSync('bash', [SCRIPT], {
    cwd: ROOT,
    env: { ...process.env, HOME: home },
    stdio: 'pipe'
  });
}

function skillRealPath(linkDir) {
  return fs.realpathSync(path.join(linkDir, 'SKILL.md'));
}

describe('gstack Cursor skill flatten', () => {
  test('project .cursor/skills/plan-ceo-review points at the vendored pack', () => {
    const dest = path.join(PROJECT_SKILLS, 'plan-ceo-review');
    expect(fs.lstatSync(dest).isSymbolicLink()).toBe(true);
    expect(fs.readlinkSync(dest)).toBe('../../.claude/skills/gstack/plan-ceo-review');
    expect(skillRealPath(dest)).toBe(
      fs.realpathSync(path.join(PACK, 'plan-ceo-review/SKILL.md'))
    );
    const md = fs.readFileSync(path.join(dest, 'SKILL.md'), 'utf8');
    expect(md).toMatch(/^name:\s*plan-ceo-review$/m);
  });

  test('router _router is exposed as the gstack slash skill', () => {
    const dest = path.join(PROJECT_SKILLS, 'gstack');
    expect(fs.lstatSync(dest).isSymbolicLink()).toBe(true);
    expect(fs.readlinkSync(dest)).toBe('../../.claude/skills/gstack/_router');
    const md = fs.readFileSync(path.join(dest, 'SKILL.md'), 'utf8');
    expect(md).toMatch(/^name:\s*gstack$/m);
  });

  test('flatten covers the nested pack without using a pack-root SKILL.md', () => {
    const names = fs.readdirSync(PROJECT_SKILLS);
    expect(names).toContain('plan-ceo-review');
    expect(names).toContain('plan-eng-review');
    expect(names).toContain('review');
    expect(names.length).toBeGreaterThanOrEqual(50);
    expect(fs.existsSync(path.join(PACK, 'SKILL.md'))).toBe(false);
  });
});

describe('all-pack Cursor skill flatten', () => {
  test('one-level SKILL.md exists for gstack, CE, improve, tdd, and find-skills', () => {
    const required = {
      'plan-ceo-review': path.join(ROOT, '.claude/skills/gstack/plan-ceo-review/SKILL.md'),
      'ce-brainstorm': path.join(ROOT, '.claude/skills/compound-engineering/ce-brainstorm/SKILL.md'),
      improve: path.join(ROOT, '.claude/skills/improve/improve/SKILL.md'),
      tdd: path.join(ROOT, '.claude/skills/pstack/tdd/SKILL.md'),
      'find-skills': path.join(ROOT, '.claude/skills/find-skills/find-skills/SKILL.md'),
      last30days: path.join(ROOT, '.claude/skills/last30days/last30days/SKILL.md'),
      hallmark: path.join(ROOT, '.claude/skills/hallmark/hallmark/SKILL.md'),
      impeccable: path.join(ROOT, '.claude/skills/impeccable/impeccable/SKILL.md'),
      'deep-research': path.join(
        ROOT,
        '.claude/skills/agent-deep-research/agent-deep-research/SKILL.md'
      )
    };
    for (const [name, real] of Object.entries(required)) {
      const dest = path.join(PROJECT_SKILLS, name);
      expect(fs.existsSync(path.join(dest, 'SKILL.md'))).toBe(true);
      expect(fs.lstatSync(dest).isSymbolicLink()).toBe(true);
      expect(skillRealPath(dest)).toBe(fs.realpathSync(real));
    }
    for (const extra of ['last30days', 'hallmark', 'impeccable', 'deep-research', 'find-skills']) {
      expect(fs.existsSync(path.join(PROJECT_SKILLS, extra, 'SKILL.md'))).toBe(true);
    }
    expect(fs.existsSync(path.join(PROJECT_SKILLS, 'openspec-propose', 'SKILL.md'))).toBe(true);
  });

  test('name collisions are prefixed and logged', () => {
    const log = fs.readFileSync(path.join(ROOT, 'docs/cursor-skill-collisions.md'), 'utf8');
    expect(log).toContain('mattpocock-tdd');
    expect(fs.existsSync(path.join(PROJECT_SKILLS, 'mattpocock-tdd', 'SKILL.md'))).toBe(true);
    expect(fs.readlinkSync(path.join(PROJECT_SKILLS, 'tdd'))).toContain('pstack/tdd');
  });
});

describe('link-agent-skills.sh behavior', () => {
  test('is idempotent and writes home ~/.cursor/skills', () => {
    const home = fs.mkdtempSync(path.join(os.tmpdir(), 'gstack-link-home-'));
    try {
      runLink(home);
      runLink(home);
      const dest = path.join(home, '.cursor/skills/plan-ceo-review');
      expect(fs.lstatSync(dest).isSymbolicLink()).toBe(true);
      expect(skillRealPath(dest)).toBe(
        fs.realpathSync(path.join(PACK, 'plan-ceo-review/SKILL.md'))
      );
      expect(fs.readdirSync(path.join(home, '.cursor/skills')).length).toBe(
        fs.readdirSync(PROJECT_SKILLS).length
      );
    } finally {
      fs.rmSync(home, { recursive: true, force: true });
    }
  }, 120000);

  test('does not replace a user-owned non-symlink skill directory', () => {
    const home = fs.mkdtempSync(path.join(os.tmpdir(), 'gstack-link-keep-'));
    const owned = path.join(home, '.cursor/skills/plan-ceo-review');
    try {
      fs.mkdirSync(owned, { recursive: true });
      fs.writeFileSync(path.join(owned, 'SKILL.md'), '---\nname: mine\n---\n');
      runLink(home);
      expect(fs.lstatSync(owned).isSymbolicLink()).toBe(false);
      expect(fs.readFileSync(path.join(owned, 'SKILL.md'), 'utf8')).toContain('name: mine');
    } finally {
      fs.rmSync(home, { recursive: true, force: true });
    }
  }, 120000);
});

describe('gstack runtime for skill preamble', () => {
  test('vendors bin/gstack-skill-start and setup in both skill roots', () => {
    for (const root of ['.claude/skills/gstack', '.agents/skills/gstack']) {
      const start = path.join(ROOT, root, 'bin/gstack-skill-start');
      const setup = path.join(ROOT, root, 'setup');
      expect(fs.existsSync(start)).toBe(true);
      expect(fs.existsSync(setup)).toBe(true);
      expect((fs.statSync(start).mode & 0o111) !== 0).toBe(true);
    }
  });

  test('gstack-skill-start emits the preamble protocol', () => {
    const start = path.join(PACK, 'bin/gstack-skill-start');
    const out = execFileSync(start, [
      '--skill', 'plan-ceo-review',
      '--model', 'claude',
      '--parent-pid', String(process.pid)
    ], { encoding: 'utf8', cwd: ROOT });
    expect(out).toContain('SKILL_START_PROTO: 1');
  });

  test('installer copies gstack runtime and flattens Cursor skills', () => {
    const installer = fs.readFileSync(path.join(ROOT, 'scripts/install-agent-skills.sh'), 'utf8');
    const linker = fs.readFileSync(SCRIPT, 'utf8');
    expect(installer).toContain('copy_gstack_runtime');
    expect(installer).toContain('link-agent-skills.sh');
    expect(linker).toContain('link_gstack_cursor_skills');
    expect(linker).toContain('link_cursor_skills');
    expect(linker).toContain('PACK_ORDER');
    expect(linker).toContain('.cursor/skills');
    expect(linker).toContain('install_cursor_mcp');
    expect(linker).toContain('*/references/*');
  });
});
