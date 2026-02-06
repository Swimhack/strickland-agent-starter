#!/bin/bash
# Sanitize files before pushing to public GitHub
# Usage: ./sanitize-for-github.sh <source-dir> <target-dir>

set -e

SOURCE_DIR="${1:-/root/.openclaw/workspace}"
TARGET_DIR="${2:-/root/dev/strickland-agent-starter}"

echo "🧹 Sanitizing files from $SOURCE_DIR to $TARGET_DIR"

# Personal data to remove (regex patterns)
declare -A REPLACEMENTS=(
  # API Keys
  ["sk-[a-zA-Z0-9_-]{48}"]="YOUR_OPENAI_API_KEY"
  ["sk-ant-[a-zA-Z0-9_-]{95,105}"]="YOUR_ANTHROPIC_API_KEY"
  ["[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}"]="YOUR_VAPI_API_KEY"
  ["KEY[a-zA-Z0-9_]{50,}"]="YOUR_TELNYX_API_KEY"
  ["AC[a-f0-9]{32}"]="YOUR_TWILIO_ACCOUNT_SID"
  ["[a-f0-9]{32}"]="YOUR_TWILIO_AUTH_TOKEN"
  
  # Phone numbers (US format)
  ["\+?1?[- ]?\(?[2-9][0-9]{2}\)?[- ]?[0-9]{3}[- ]?[0-9]{4}"]="1234567890"
  
  # Email addresses (but keep example.com)
  ["[a-zA-Z0-9._%+-]+@(?!example\.com)[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"]="user@example.com"
  
  # Stripe keys
  ["sk_live_[a-zA-Z0-9]{99}"]="YOUR_STRIPE_LIVE_KEY"
  ["sk_test_[a-zA-Z0-9]{99}"]="YOUR_STRIPE_TEST_KEY"
  
  # GitHub tokens
  ["ghp_[a-zA-Z0-9]{36}"]="YOUR_GITHUB_TOKEN"
)

# Files to exclude from processing
EXCLUDE_PATTERNS=(
  "*.git*"
  "node_modules/*"
  "*.log"
  ".env"
)

# Function to sanitize a single file
sanitize_file() {
  local file="$1"
  local temp_file="${file}.tmp"
  
  cp "$file" "$temp_file"
  
  for pattern in "${!REPLACEMENTS[@]}"; do
    replacement="${REPLACEMENTS[$pattern]}"
    # Use perl for better regex support
    perl -pi -e "s/$pattern/$replacement/g" "$temp_file" 2>/dev/null || true
  done
  
  # Show diff if changes were made
  if ! diff -q "$file" "$temp_file" > /dev/null 2>&1; then
    echo "  ✓ Sanitized: $file"
    mv "$temp_file" "$file"
    return 0
  else
    rm "$temp_file"
    return 1
  fi
}

# Find and sanitize all relevant files
file_count=0
sanitized_count=0

while IFS= read -r -d '' file; do
  ((file_count++))
  if sanitize_file "$file"; then
    ((sanitized_count++))
  fi
done < <(find "$TARGET_DIR" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.md" -o -name "*.json" -o -name "*.sh" \) -print0)

echo ""
echo "📊 Summary:"
echo "  Files checked: $file_count"
echo "  Files sanitized: $sanitized_count"
echo ""
echo "⚠️  Manual Review Required:"
echo "  - Check for hardcoded addresses (2213 Foster Rd, Katy TX, etc.)"
echo "  - Verify no customer names remain"
echo "  - Ensure .env.example has all required variables"
echo "  - Test that examples work with placeholder data"
echo ""
echo "✅ Ready to commit and push? Review changes with: git diff"
