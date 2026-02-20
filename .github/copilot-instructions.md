# Repo overview
This is a tiny demo repository used by HashiCorp to show how to use
[HCP Terraform](https://app.terraform.io/) with the Terraform CLI.  All of the
real work is done by the `fakewebservices` provider, which creates pretend
infrastructure in a made‑up cloud called *Fake Web Services*.

The configuration is intentionally simple:

* `main.tf` defines a VPC, two servers, a load balancer and a database.
* `provider.tf` declares the provider and exposes a `provider_token` variable
  (marked `sensitive`) so that the remote backend can run with your token.
* `backend.tf` is a template for the `terraform { cloud { … } }` block.  The
  `scripts/setup.sh` script replaces the `{{ORGANIZATION_NAME}}`/`
  {{WORKSPACE_NAME}}` placeholders and optionally adds a hostname when you
  target something other than `app.terraform.io`.
* `scripts/setup.sh` orchestrates the initial bootstrap: it checks for
  required tools, ensures you have a login token, creates the HCP org/workspace
  via the HCP API, patches `backend.tf`/`provider.tf`, and runs `terraform
  init/plan/apply`.

Because the backend is remote, Terraform operations (`init`, `plan`, `apply`)
are executed in HCP Terraform rather than locally.  The setup script is the
primary developer workflow and is documented in the repo README.

# Architecture & data flow
1. Clone the repository and log in (`terraform login`).
2. Run `./scripts/setup.sh`.
   * The script posts to the HCP Terraform API to create an organization and
     workspace.
   * It writes the credentials into `backend.tf` (and optionally
     `provider.tf`) and initializes the workspace.
3. Modify `main.tf` as you like; any `terraform` command will now talk to the
   remote backend.

The provider token is only passed via the variable in `provider.tf` because the
backend operates remotely; the setup script does not hardcode the token.

# Developer workflows
* **Initial setup**: run `./scripts/setup.sh`; follow interactive prompts.
  The script verifies `terraform`, `sed`, `curl`, and `jq` are installed, and
  guards against re‑running if you have local changes.
* **Modify configuration**: edit `main.tf` or add new `.tf` files; use standard
  `terraform init`, `terraform plan`, and `terraform apply` commands after
  setup. The minimum required Terraform version is `>= 1.1.2` (configured in
  `backend.tf`), but the script checks for `>= 0.14`.
* **Reset state**: deleting `.terraform` and the workspace via the HCP UI lets
  you start over; the setup script will reset `backend.tf` and
  `provider.tf` if you re‑run it with a clean git tree.

# Conventions & patterns
* Placeholders in Terraform files use `{{…}}` so the shell script can `sed`
  replace them.  Do **not** rename or reformat those lines; the setup script
  expects them at fixed line numbers.
* Shell script styling follows HashiCorp conventions: `set -euo pipefail`,
  helper functions (`info`, `success`, `fail`), and a trap for SIGINT.
* Git cleanliness is enforced before destructive operations—the script refuses
  to overwrite uncommitted changes.
* `provider_token` is declared but never given a default; it’s meant to be
  populated by Terraform when the backend executes remotely, thus keeping the
  token out of version control.

# External integrations
* **HCP Terraform API**: `scripts/setup.sh` calls
  `https://$HOST/api/getting-started/setup` to provision an org/workspace.
* **Terraform CLI**: all operations rely on a user‐installed CLI; the script
  parses `terraform version -json` with `jq`.
* **fakewebservices provider**: nothing in this repo implements logic for the
  provider; check the registry mentioned in `main.tf` for its resource schema.

# Things an AI agent should know
* There is no build system or tests; the only executable is the `setup.sh`
  script, which also demonstrates most of the repo's behavior.
* Changing `backend.tf` or `provider.tf` manually is unusual; prefer using the
  setup script to keep placeholder patterns intact.
* The repository is intentionally minimal—avoid over‑engineering and keep
  changes aligned with the “getting started” purpose.  For example, do not
  introduce unrelated Terraform modules or complex provider logic.
* Ensure shell changes respect the existing guard clauses and output styles.

---

**Next steps?** After you’ve written or updated instructions, please let me
know if any section lacks clarity or misses important project‑specific
details.