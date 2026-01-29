#!/bin/bash
# Strickland AI Agent - Stop Script

echo "Stopping Strickland AI Agent..."

# Try graceful shutdown first
if command -v clawdbot &> /dev/null; then
    clawdbot stop 2>/dev/null || true
elif command -v moltbot &> /dev/null; then
    moltbot stop 2>/dev/null || true
fi

# Kill any remaining processes
pkill -f "clawdbot" 2>/dev/null || true
pkill -f "moltbot" 2>/dev/null || true

echo "Agent stopped."
