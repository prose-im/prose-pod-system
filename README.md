# prose-pod-system

[![Test](https://github.com/prose-im/prose-pod-system/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/prose-im/prose-pod-system/actions/workflows/test.yml)

**Prose Pod system configurations and build rules. Used to package everything together.**

Copyright 2022, Prose Foundation - Released under the [Mozilla Public License 2.0](./LICENSE.md).

## Launching both the XMPP server and the Admin API

To launch both the XMPP server (`prose-pod-server`) and the Admin API (`prose-pod-api`), you can use [Docker Compose](https://docs.docker.com/compose/).

First, create a `.env` file at the repository root containing required secrets and localhost overrides:

```bash
export JWT_SIGNING_KEY='<INSERT_JWT_SIGNING_KEY>'
export PROSE_BOOTSTRAP__PROSE_POD_API_XMPP_PASSWORD='<INSERT_VERY_STRONG_PASSWORD>'
export PROSE_SERVER__DOMAIN='prose.org.local'
export RUST_LOG='debug,sqlx=warn,hyper=warn,hyper_util=warn'
```

Then, run `docker compose up` and everything should work.

## Tools

Some tools are available to ease working on Prose:

- **Bootstrap local Prose server** (without the admin API): `./tools/bootstrap.sh [environment]`
  - `[environment]`: _defaults to `local`_

## License

Licensing information can be found in the [LICENSE.md](./LICENSE.md) document.

## :fire: Report A Vulnerability

If you find a vulnerability in any Prose system, you are more than welcome to report it directly to Prose Security by sending an encrypted email to [security@prose.org](mailto:security@prose.org). Do not report vulnerabilities in public GitHub issues, as they may be exploited by malicious people to target production systems running an unpatched version.

**:warning: You must encrypt your email using Prose Security GPG public key: [:key:57A5B260.pub.asc](https://files.prose.org/public/keys/gpg/57A5B260.pub.asc).**
