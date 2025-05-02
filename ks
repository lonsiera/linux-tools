#!/bin/bash
#  ./ks               # Lists clusters and their contexts
#  ./ks context-name  # Switches to specified context

# Check if kubectl is installed
command -v kubectl >/dev/null 2>&1 || { echo >&2 "kubectl is required but not installed. Aborting."; exit 1; }

# Get current context
CURRENT_CONTEXT=$(kubectl config current-context)

# No arguments: list contexts with clusters
if [ $# -eq 0 ]; then
  kubectl config get-contexts
  exit 0
fi

# Argument provided: treat it as a context name
CONTEXT_NAME="$1"

# Check if the context exists
if ! kubectl config get-contexts -o name | grep -qx "$CONTEXT_NAME"; then
  echo "No context named '$CONTEXT_NAME' found in kubeconfig."
  exit 1
fi

# Switch to the given context
kubectl config use-context "$CONTEXT_NAME"
#echo "Switched to context '$CONTEXT_NAME'"