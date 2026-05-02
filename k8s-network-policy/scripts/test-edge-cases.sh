#!/usr/bin/env bash
# Test connectivity for edge-case scenarios.
# Tests: same-ns client → server, cross-ns (ml-ops) → server
set -uo pipefail

TIMEOUT=3

test_conn() {
  local ns="$1" deploy="$2" target_url="$3" label="$4"
  if kubectl -n "$ns" exec "deploy/$deploy" -- wget -qO- --timeout="$TIMEOUT" "$target_url" >/dev/null 2>&1; then
    echo -e "  $label  \e[32m✅ ALLOWED\e[0m"
  else
    echo -e "  $label  \e[31m❌ BLOCKED\e[0m"
  fi
}

echo ""
echo "Edge-Case Connectivity Tests"
echo "============================="
echo ""
echo "Target: server pod in 'edge-cases' namespace"
echo ""
test_conn edge-cases   client          http://server                                "Same NS (client → server)           "
test_conn ml-ops       model-monitor   http://server.edge-cases.svc.cluster.local   "Cross NS (model-monitor → server)   "
test_conn ml-ops       drift-detector  http://server.edge-cases.svc.cluster.local   "Cross NS (drift-detector → server)  "
test_conn ai-platform  chat-ui         http://server.edge-cases.svc.cluster.local   "Cross NS (chat-ui → server)         "
echo ""
