GitHub Spec Kit command templates vendored as Agent Skills (pinned to tag v1.0.1).

Do not run `specify init` in this Express app — that would dump a Spec Kit project into application source.

For a greenfield repo:
  specify init --here --integration cursor-agent

Pin the CLI from the Git tag (not a random PyPI specify-cli):
  uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v1.0.1

Pick Spec Kit XOR gstack XOR Compound Engineering for spec. Never run CE + gstack + Superpowers + pstack on the same task.
