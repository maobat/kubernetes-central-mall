#!/bin/bash
# check-answers-labs.sh
# Verifies CKAD Simulator Lab Answers (Question 1 & 2 Demo)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Starting CKAD Simulator Labs Verification (Q1-Q2) ===${NC}\n"

# Helper for grading
function grade() {
    local q=$1
    local status=$2
    local msg=$3
    if [ "$status" -eq 0 ]; then
        echo -e "${GREEN}[PASS] Question $q: $msg${NC}"
    else
        echo -e "${RED}[FAIL] Question $q: $msg${NC}"
    fi
}

# --- Q1 ---
# /opt/course/1/namespaces should exist and have content
if [ -f "/opt/course/1/namespaces" ] && [ -s "/opt/course/1/namespaces" ]; then
    grade "1" 0 "File /opt/course/1/namespaces exists and is not empty."
else
    grade "1" 1 "File /opt/course/1/namespaces is missing or empty."
fi

# --- Q2 ---
# pod1 in default namespace, container named pod1-container, script /opt/course/2/pod1-status-command.sh exists
pod1_exists=$(kubectl get pod pod1 -n default -o jsonpath='{.metadata.name}' 2>/dev/null)
pod1_container=$(kubectl get pod pod1 -n default -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$pod1_exists" == "pod1" ] && [ "$pod1_container" == "pod1-container" ] && [ -f "/opt/course/2/pod1-status-command.sh" ] && [ -x "/opt/course/2/pod1-status-command.sh" ]; then
    grade "2" 0 "Pod 'pod1' and helper script '/opt/course/2/pod1-status-command.sh' are correct."
else
    grade "2" 1 "Pod 'pod1' or helper script is incorrect or missing."
fi

echo -e "\n${YELLOW}=== Verification Finished ===${NC}"
