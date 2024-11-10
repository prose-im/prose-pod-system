# Usage guidelines

This repository is meant to be used in various ways. This guide explains how to start a Prose Pod or Prose Pod Server depending on your use case.

## Starting a Prose Pod

> [!TIP]
> This is the recommended way to start a Prose Pod. This will launch all components of a Pod.

To launch both the XMPP server (`prose-pod-server`) and the Admin API (`prose-pod-api`), you can use [Docker Compose](https://docs.docker.com/compose/).

### Use case: Running a Prose Pod locally (with persisting data)

1. ### Configure the Prose Pod

   Some static configuration is required to bootstrap and run a Prose Pod. Here is how you can copy the templates:

   ```bash
   cd PROSE_POD_SYSTEM_DIR # Replace with your path to `prose-pod-system`
   cp Prose-template.toml Prose.toml
   cp template.env .env
   ```

   Then, edit `Prose.toml` and `.env` to fill it with your own configuration.

2. ### Create the API database

   The Prose Pod API uses a [SQLite] database so you need to create one:

   ```bash
   touch database.sqlite
   ```

   Tip: You can change the database location by setting `DATABASE_PATH` before running `docker compose up`.

3. ### Copy the filesystem

   While you *could* start the Prose Pod mounting its filesystem on `./server/pod`, you should copy it to avoid loosing data when running `tools/cleanup`. You can easily do so by running:

   ```bash
   cp -R ./server/pod ./pod-fs-root
   ```

4. ### Run the Prose Pod

   Finally, run the Prose Pod using:

   ```bash
   SERVER_ROOT=./pod-fs-root docker compose up
   ```

   Tip: If you just want to check that the Prose Pod starts correctly, you can run:

   ```bash
   PROSE_CONFIG_FILE="$(pwd)/Prose-example.toml" docker compose up
   ```

### Use case: Running an ephemeral Prose Pod locally (e.g. for quick integration tests)

```bash
ENV_FILE=PATH_TO_ENV_FILE \
PROSE_CONFIG_FILE=PATH_TO_PROSE_TOML \
SERVER_ROOT=PATH_TO_SERVER_FS_ROOT \
docker compose up
```

See [`prose-pod-api/scripts/integration-test`] for a real-life example.

### Use case: Running an ephemeral Prose Pod on a Raspberry Pi (e.g. for complete integration tests)

> [!WARNING]
> This section is pretty advanced and requires a complex setup. It's not intended for everyone, just for the few maintainers who'd like to run the full integration test suite at home.

Since integration tests are located in the [`prose-pod-api`] repository, helper scripts are located under [`prose-pod-api/scripts/prose-pod-on-rpi/`].

```bash
cd PATH_TO_PROSE_POD_API
# Initialize the Prose Pod.
./scripts/prose-pod-on-rpi/init --help
# Cleanup the Prose Pod between test runs.
./scripts/prose-pod-on-rpi/cleanup --help
# Deinitialize (delete) the Prose Pod.
./scripts/prose-pod-on-rpi/deinit --help
```

## Starting only a Prose Pod Server

> [!NOTE]
> Most likely, you are looking to start a whole Prose Pod, not only the Prose Pod Server sub-system. Please refer to the [above section](#starting-a-prose-pod) on how to start a whole Prose Pod instead.

How to bootstrap local Prose server (without the admin API):

```bash
./tools/bootstrap ENVIRONMENT
```

The following options can be provided:

- `ENVIRONMENT`: `local` or `pod` (directories under [`server/`](./server)). Defaults to `local`.

[`prose-pod-api/scripts/prose-pod-on-rpi/`]: https://github.com/prose-im/prose-pod-api/tree/master/scripts/prose-pod-on-rpi "prose-pod-api/scripts/prose-pod-on-rpi at master · prose-im/prose-pod-api"
[`prose-pod-api/scripts/integration-test`]: https://github.com/prose-im/prose-pod-api/blob/78cdb14827999f590a5fcff37ef2bd838b30a1b4/scripts/integration-test "prose-pod-api/scripts/integration-test at 78cdb14827999f590a5fcff37ef2bd838b30a1b4 · prose-im/prose-pod-api"
[`prose-pod-api`]: https://github.com/prose-im/prose-pod-api "prose-im/prose-pod-api: Prose Pod API server. REST API used for administration and management."
[SQLite]: https://www.sqlite.org/index.html "SQLite homepage"
