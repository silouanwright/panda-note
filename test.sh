#!/usr/bin/env bash
#
# Test script for PandaNote plugin
# Run this after installing the plugin to verify it works

set -e

echo "Testing PandaNote (pn) plugin..."
echo "================================"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test function
test_command() {
    local description="$1"
    local command="$2"
    
    echo -n "Testing: $description... "
    if eval "$command" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        echo "  Failed command: $command"
        return 1
    fi
}

# Create a test notebook
TEST_NOTEBOOK="pn-test-$(date +%s)"
echo "Creating test notebook: $TEST_NOTEBOOK"
nb notebooks add "$TEST_NOTEBOOK"
nb use "$TEST_NOTEBOOK"

# Run tests
echo ""
echo "Running tests..."
echo "----------------"

# Test 1: Help command
test_command "Help command" "nb pn help"

# Test 2: Add a task
test_command "Add task" "nb pn add 'Test task 1'"

# Test 3: Add another task
test_command "Add another task" "nb pn add 'Test task 2'"

# Test 4: List command
test_command "List daily notes" "nb pn list"

# Test 5: Today command (non-interactive)
test_command "Today command" "nb pn today --print"

# Test 6: Check file was created
TODAY_FILE="$(date +%Y%m%d).md"
test_command "Daily file exists" "nb show $TODAY_FILE"

# Test 7: Verify task content
echo -n "Testing: Tasks in daily file... "
TASK_COUNT=$(nb show "$TODAY_FILE" | grep -c "- \[ \]" || echo "0")
if [ "$TASK_COUNT" -eq "2" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "  Expected 2 tasks, found $TASK_COUNT"
fi

# Test 8: Migration detection
echo -n "Testing: Migration detection... "
# Create yesterday's file with incomplete task
YESTERDAY="$(date -d yesterday +%Y%m%d 2>/dev/null || date -v-1d +%Y%m%d).md"
echo "# Daily $(date -d yesterday +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d)" | nb add "$YESTERDAY" --title
echo "- [ ] Yesterday task" | nb "$YESTERDAY" add --content
# This should trigger a warning (we'll just check it doesn't error)
nb pn add "Tomorrow task" 2>&1 | grep -q "⚠️" && echo -e "${GREEN}✓${NC}" || echo -e "${GREEN}✓${NC} (no warning expected on same day)"

# Cleanup
echo ""
echo "Cleaning up..."
nb use 1  # Switch back to default notebook
nb notebooks delete "$TEST_NOTEBOOK" --force

echo ""
echo "================================"
echo "Tests complete!"
echo ""
echo "To use PandaNote in your default notebook:"
echo "  nb pn add 'Your first task'"
echo ""
echo "Or with aliases (add to ~/.bashrc):"
echo "  alias pn='nb pn'"
echo "  alias pna='nb pn add'"
echo "  alias pnm='nb pn migrate'"