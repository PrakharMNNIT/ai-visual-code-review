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
  'addyosmani'
];

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
    for (const pack of ['Superpowers', 'improve (shadcn)', 'Cursor Team Kit', 'Vercel Agent Skills', 'Addy Osmani']) {
      expect(index).toContain(pack);
    }
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
