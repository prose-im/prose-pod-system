# Usage guidelines

This repository is meant to be used in various ways. This guide explains how to start a Prose Pod or Prose Pod Server depending on your use case.

## Starting a Prose Pod {#starting-pod}

To launch both the XMPP server (`prose-pod-server`) and the Admin API (`prose-pod-api`), you can use [Docker Compose](https://docs.docker.com/compose/).

### Creating the

First, create a `.env` file at the repository root containing required secrets and localhost overrides:

```bash
export JWT_SIGNING_KEY='<INSERT_JWT_SIGNING_KEY>'
export PROSE_BOOTSTRAP__PROSE_POD_API_XMPP_PASSWORD='<INSERT_VERY_STRONG_PASSWORD>'
export RUST_LOG='debug,sqlx=warn,hyper=warn,hyper_util=warn'
```

### Use case: Running a Prose Pod locally (with persisting data) {#running-pod-persistent}

1. ### Configure the Prose Pod {#running-pod-persistent-configure}

   Some static configuration is required to bootstrap and run a Prose Pod. Here is how you can copy the templates:

   ```bash
   cd PROSE_POD_SYSTEM_DIR # Replace with your path to `prose-pod-system`
   cp Prose-template.toml Prose.toml
   cp template.env .env
   ```

   Then, edit `Prose.toml` and `.env` to fill it with your own configuration.

2. ### Create the API database {#running-pod-persistent-create-db}

   The Prose Pod API uses a [SQLite] database so you need to create one:

   ```bash
   touch database.sqlite
   ```

   > [!TIP]
   > You can change the database location by setting `DATABASE_PATH` before running `docker compose up`.

3. ### Copy the filesystem {#running-pod-persistent-copy-fs}

   While you *could* start the Prose Pod mounting its filesystem on `./server/pod`, you should copy it to avoid loosing data when running `tools/cleanup.sh`. You can easily do so by running:

   ```bash
   cp -R ./server/pod ./pod-fs-root
   ```

4. ### Run the Prose Pod {#running-pod-persistent-run}

   Finally, run the Prose Pod using:

   ```bash
   SERVER_ROOT=./pod-fs-root docker compose up
   ```

   > [!TIP]
   > If you just want to check that the Prose Pod starts correctly, you can run:
   >
   > ```bash
   > PROSE_CONFIG_FILE="$(pwd)/Prose-example.toml" docker compose up
   > ```

### Use case: Running an ephemeral Prose Pod locally (e.g. for quick integration tests) {#running-pod-ephemeral-local}

```bash
ENV_FILE=PATH_TO_ENV_FILE \
PROSE_CONFIG_FILE=PATH_TO_PROSE_TOML \
SERVER_ROOT=PATH_TO_SERVER_FS_ROOT \
docker compose up
```

> [!TIP]
> See [`prose-pod-api/scripts/integration-test.sh`] for a real-life example.

### Use case: Running an ephemeral Prose Pod on a Raspberry Pi (e.g. for complete integration tests) {#running-pod-ephemeral-rpi}

> [!WARNING]
> This section is pretty advanced and requires a complex setup. It's not intended for everyone, just for the few maintainers who'd like to run the full integration test suite at home.

> [!IMPORTANT]
> Since integration tests are located in the [`prose-pod-api`] repository, helper scripts are located under [`prose-pod-api/scripts/`].

## Starting only a Prose Pod Server {#starting-a-prose-pod-server}

[`prose-pod-api/scripts/`]: https://github.com/prose-im/prose-pod-api/tree/master/scripts "prose-pod-api/scripts at master · prose-im/prose-pod-api"
[`prose-pod-api/scripts/integration-test.sh`]: https://github.com/prose-im/prose-pod-api/blob/835aff62591682842d5740f0f651830f6055fdf8/scripts/integration-test.sh "prose-pod-api/scripts/integration-test.sh at 835aff62591682842d5740f0f651830f6055fdf8 · prose-im/prose-pod-api"
[`prose-pod-api`]: https://github.com/prose-im/prose-pod-api "prose-im/prose-pod-api: Prose Pod API server. REST API used for administration and management."
[SQLite]: https://www.sqlite.org/index.html "SQLite homepage"
