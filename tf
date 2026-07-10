#!/usr/bin/env bash
# Обвивка около terraform: ./tf <stack> <команда> [args...]
#   ./tf bootstrap init && ./tf bootstrap apply
#   ./tf vpc init && ./tf vpc apply -auto-approve
#   ./tf gke output
#
# Прави две неща, които terraform не може сам:
# 1. Инжектира bucket/prefix на init (backend блокът не приема
#    променливи -> partial backend config е каноничният отговор)
# 2. Export-ва TF_VAR_* от env.sh -> всеки stack си взема каквото
#    декларира; недекларираните TF_VAR_* се игнорират тихо
set -euo pipefail
cd "$(dirname "$0")"
source ./env.sh

STACK="${1:?usage: ./tf <stack> <terraform-cmd> [args] | stacks: bootstrap vpc gke artifact-registry lb}"
shift

case "$STACK" in
  bootstrap)          DIR="bootstrap" ;;
  vpc)                DIR="europe-west1/vpc" ;;
  gke)                DIR="europe-west1/gke" ;;
  artifact-registry|ar) DIR="europe-west1/artifact-registry"; STACK="artifact-registry" ;;
  lb)                 DIR="europe-west1/lb" ;;
  *) echo "unknown stack: $STACK (bootstrap|vpc|gke|artifact-registry|lb)"; exit 1 ;;
esac

export TF_VAR_project_id="$PROJECT_ID"
export TF_VAR_region="$REGION"
export TF_VAR_github_owner="$GITHUB_OWNER"
export TF_VAR_cluster_name="$CLUSTER_NAME"

CMD="${1:?terraform command required (init/plan/apply/destroy/output/...)}"
shift || true
cd "$DIR"

if [[ "$CMD" == "init" ]]; then
  if [[ "$STACK" == "bootstrap" ]]; then
    # bootstrap-ът е на ЛОКАЛЕН state (той създава bucket-а —
    # кокошката и яйцето се чупи като не му даваме remote backend)
    terraform init "$@"
  else
    # -reconfigure е задължителен при sandbox ротация: .terraform/
    # кешира стария bucket и без него init отказва да смени backend
    terraform init -reconfigure \
      -backend-config="bucket=${BUCKET}" \
      -backend-config="prefix=europe-west1/${STACK}.tfstate" \
      "$@"
  fi
else
  terraform "$CMD" "$@"
fi
