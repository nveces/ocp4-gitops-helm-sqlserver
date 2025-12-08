#!/bin/bash
#
# ============================================================
#
#
# ============================================================
# Description---:
#
#
# ============================================================
#
# chmod 774 *.sh
#
#
# EOH

set -euo pipefail
#set -uo pipefail

# Step 1: Set current DIR and default variables:
V_ADMIN_DIR=$(dirname $0)
source ${V_ADMIN_DIR}/00-functions.sh

PRJ_NAME=dbaas-lab
MSSQL_SECRET_NAME=mssql
OUTPUT_DIR=${V_ADMIN_DIR}/../templates/
OUTPUT_YAML="-o yaml --dry-run=client "
MSSQL_SECRET_YAML=${OUTPUT_DIR}/04-secret-mssql-sa.yaml

# oc create secret generic mssql --from-literal=MSSQL_SA_PASSWORD='tEstSa!0' -n dbaas-lab -o yaml --dry-run=client
# Step 1: Create YAML secret (warning: password variable and single quotes)
oc create secret generic ${MSSQL_SECRET_NAME} --from-literal='MSSQL_SA_PASSWORD=tEstSa!0' \
  --type=Opaque -n ${PRJ_NAME} \
  ${OUTPUT_YAML} > ${OUTPUT_DIR}/${MSSQL_SECRET_YAML}

exit 0

# EOF