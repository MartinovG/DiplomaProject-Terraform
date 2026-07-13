#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════
#  ЕДИНСТВЕНИЯТ ФАЙЛ, КОЙТО ПИПАШ ПРИ НОВ SANDBOX — един ред:
# ════════════════════════════════════════════════════════════════
export PROJECT_ID="playground-s-11-8ef2326d"

# всичко останало е ПРОИЗВОДНО — не пипай:
export REGION="europe-west1"
export GITHUB_OWNER="MartinovG"
export CLUSTER_NAME="dp-gcp-migration-gke"
# bucket името следва project ID-то: глобално уникално по
# конструкция + няма колизии със soft-deleted bucket-и от
# предишни sandbox-и (GCS имената са глобални за цял GCP)
export BUCKET="${PROJECT_ID}-tf-state"
