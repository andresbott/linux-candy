# linux-candy
mixed small candy scripts for linux

All the scripts are unified into a single `candy` executable (installed to
`/usr/local/bin/candy`) that dispatches to a subcommand per task. Run `candy`
with no arguments to list the available commands:

```
candy                    # list commands
candy snapscreen -t s    # screenshot a selection (or -t w for a window)
candy public-ip          # print the public IP
candy topsize -n 3       # biggest directories under the current path
```

## Build

Build the `.deb` package locally into `dist/` (requires [nfpm](https://nfpm.goreleaser.com)):

```
make build
```

The package version defaults to `git describe` (or `0.0.0-dev` before the first
tag). Override it with `make build VERSION=v0.1.4`.

## Release

Releases are cut by pushing a `v*` tag: the `Release` GitHub Actions workflow
then builds the `.deb` with nfpm and publishes a GitHub release with the package
attached.

```
make tag version="v0.1.4"
```

`make tag` refuses to run unless you are on `main` with a clean working tree.
