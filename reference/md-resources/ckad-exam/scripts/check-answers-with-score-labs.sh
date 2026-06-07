#!/bin/bash
# check-answers-labs.sh
# Verifies CKAD Simulator Lab Answers with Real Exam Point Weights

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Starting CKAD Simulator Labs Verification ===${NC}\n"

# Score Tracking Engine
TOTAL_SCORE=0
MAX_SCORE=0

# Helper for grading with weights
function grade() {
    local q=$1
    local status=$2
    local weight=$3
    local msg=$4
    
    # Track maximum possible exam points
    MAX_SCORE=$((MAX_SCORE + weight))
    
    if [ "$status" -eq 0 ]; then
        echo -e "${GREEN}[PASS] Question $q (${weight}%): $msg${NC}"
        TOTAL_SCORE=$((TOTAL_SCORE + weight))
    else
        echo -e "${RED}[FAIL] Question $q (${weight}%): $msg${NC}"
    fi
}

# --- Q1 (Weight: 2%) ---
if [ -f "/opt/course/1/namespaces" ] && [ -s "/opt/course/1/namespaces" ]; then
    grade "1" 0 2 "File /opt/course/1/namespaces exists and is not empty."
else
    grade "1" 1 2 "File /opt/course/1/namespaces is missing or empty."
fi

# --- Q2 (Weight: 3%) ---
pod1_exists=$(kubectl get pod pod1 -n default -o jsonpath='{.metadata.name}' 2>/dev/null)
pod1_container=$(kubectl get pod pod1 -n default -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$pod1_exists" == "pod1" ] && [ "$pod1_container" == "pod1-container" ] && [ -f "/opt/course/2/pod1-status-command.sh" ] && [ -x "/opt/course/2/pod1-status-command.sh" ]; then
    grade "2" 0 3 "Pod 'pod1' and helper script '/opt/course/2/pod1-status-command.sh' are correct."
else
    grade "2" 1 3 "Pod 'pod1' or helper script is incorrect or missing."
fi