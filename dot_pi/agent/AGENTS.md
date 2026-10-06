Before modifying files, ask for explicit approval unless the user clearly asks you to implement, build, fix, or apply the change.

## CodeGraph

When the current project has a `.codegraph/` index, use `codegraph_explore` before multi-file debugging, refactoring, or implementation to understand flows, callers, dependencies, and blast radius. Use `find` and `grep` for exact path or text lookups. If CodeGraph is unavailable or insufficient, fall back to the native tools.
