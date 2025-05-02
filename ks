#!/bin/bash
#  ./ks               # Lists clusters and their contexts
#  ./ks cluster-name  # Switches based on cluster name

# Check if kubectl is installed
command -v kubectl >/dev/null 2>&1 || { echo >&2 "kubectl is required but not installed. Aborting."; exit 1; }

# No arguments: list clusters from current kubeconfig
if [ $# -eq 0 ]; then
  echo "Available clusters from kubeconfig:"
  kubectl config get-contexts -o name | while read -r ctx; do
    cluster=$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$ctx\")].context.cluster}")
    echo "Cluster: $cluster  (Context: $ctx)"
  done
  exit 0
fi

# Argument provided: treat it as a cluster name
CLUSTER_NAME="$1"

# Find context matching the given cluster
MATCHING_CONTEXT=$(kubectl config view -o jsonpath="{.contexts[?(@.context.cluster==\"$CLUSTER_NAME\")].name}")

if [ -z "$MATCHING_CONTEXT" ]; then
  echo "No context found using cluster name '$CLUSTER_NAME'"
  exit 1
fi

# Switch to that context
kubectl config use-context "$MATCHING_CONTEXT"
echo "Switched to context '$MATCHING_CONTEXT' for cluster '$CLUSTER_NAME'"
