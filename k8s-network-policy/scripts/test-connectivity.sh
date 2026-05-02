#!/usr/bin/env bash
# Quick connectivity test for the RAG app — run after each policy change.
# Green (✅) = connection succeeded, Red (❌) = connection failed/timed out.
set -uo pipefail

NS="ai-platform"
TIMEOUT=3

test_connectivity() {
  local from="$1" to="$2" port="$3" label="$4"
  if kubectl -n "$NS" exec "deploy/$from" -- wget -qO- --timeout="$TIMEOUT" "http://${to}:${port}" >/dev/null 2>&1; then
    echo -e "  $label  \e[32m✅ ALLOWED\e[0m"
  else
    echo -e "  $label  \e[31m❌ BLOCKED\e[0m"
  fi
}

echo ""
echo "Network Connectivity Matrix (namespace: $NS)"
echo "============================================="
test_connectivity chat-ui    rag-api    8000  "Chat UI  → RAG API  "
test_connectivity rag-api    vector-db  6333  "RAG API  → Vector DB"
test_connectivity chat-ui    vector-db  6333  "Chat UI  → Vector DB"
test_connectivity vector-db  chat-ui    3000  "Vector DB → Chat UI "
test_connectivity vector-db  rag-api    8000  "Vector DB → RAG API "
test_connectivity rag-api    chat-ui    3000  "RAG API  → Chat UI  "
echo ""
