# Maintenance

## Freeing disk space

### uv

uv keeps one cache for every package it has downloaded or built, shared by
all projects. To see where it is and how large it has grown:

```console
du -sh "$(uv cache dir)"
```

Remove the entries no project uses any more:

```console
uv cache prune
```

Or empty the cache entirely; the next install downloads everything again:

```console
uv cache clean
```

Each project's `.venv` can be rebuilt from its `pyproject.toml` and
`uv.lock` with `uv sync`. To list them with their sizes:

```console
find ~ -type d -name .venv -prune -exec du -sh {} +
```

Then delete the ones you no longer use:

```console
rm -rf <project>/.venv
```

On a shared account, delete only your own projects' `.venv`: anyone else's
project stops working until they run `uv sync`.
