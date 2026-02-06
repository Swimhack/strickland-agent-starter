#!/usr/bin/env node

/**
 * Make AI Voice Call via Vapi
 * Usage: node make-call.js --agent-id <id> --phone <number>
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

// Load OpenClaw config for Vapi API key
function loadConfig() {
  const configPath = path.join(process.env.HOME, '.openclaw', 'openclaw.json');
  if (!fs.existsSync(configPath)) {
    console.error('❌ OpenClaw config not found. Run setup first.');
    process.exit(1);
  }
  return JSON.parse(fs.readFileSync(configPath, 'utf8'));
}

// Make Vapi API request
function vapiRequest(method, endpoint, data = null) {
  const config = loadConfig();
  const apiKey = config.integrations?.vapi?.apiKey;
  
  if (!apiKey || apiKey === 'configure-later') {
    console.error('❌ Vapi API key not configured. Add it to openclaw.json');
    process.exit(1);
  }
  
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'api.vapi.ai',
      path: endpoint,
      method,
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json'
      }
    };

    const req = https.request(options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          resolve(JSON.parse(body));
        } catch (e) {
          reject(new Error(`Invalid response: ${body}`));
        }
      });
    });

    req.on('error', reject);
    if (data) req.write(JSON.stringify(data));
    req.end();
  });
}

// Parse command line arguments
function parseArgs() {
  const args = process.argv.slice(2);
  const parsed = {};
  
  for (let i = 0; i < args.length; i += 2) {
    const key = args[i].replace(/^--/, '');
    const value = args[i + 1];
    parsed[key] = value;
  }
  
  return parsed;
}

// Make the call
async function makeCall() {
  const args = parseArgs();
  
  if (!args['agent-id'] || !args['phone']) {
    console.log(`
Usage: node make-call.js --agent-id <id> --phone <number>

Required:
  --agent-id    Vapi assistant ID
  --phone       Phone number (E.164 format, e.g. +18005551234)

Optional:
  --lead-id     Lead ID (for tracking)
  --metadata    JSON metadata string

Example:
  node make-call.js --agent-id abc123 --phone +18325551234
    `);
    process.exit(1);
  }
  
  const phoneNumber = args['phone'].startsWith('+') ? args['phone'] : `+1${args['phone']}`;
  
  // Get phone number ID (use first available)
  console.log('📞 Looking up phone numbers...');
  const phoneNumbers = await vapiRequest('GET', '/phone-number');
  
  if (!phoneNumbers || phoneNumbers.length === 0) {
    console.error('❌ No phone numbers configured in Vapi. Add one first.');
    process.exit(1);
  }
  
  const phoneNumberId = phoneNumbers[0].id;
  
  // Prepare call data
  const callData = {
    assistantId: args['agent-id'],
    phoneNumberId: phoneNumberId,
    customer: {
      number: phoneNumber
    }
  };
  
  // Add optional metadata
  if (args['lead-id'] || args['metadata']) {
    callData.metadata = {
      leadId: args['lead-id'],
      ...(args['metadata'] ? JSON.parse(args['metadata']) : {})
    };
  }
  
  console.log(`📞 Calling ${phoneNumber}...`);
  console.log(`   Agent: ${args['agent-id']}`);
  console.log(`   From: ${phoneNumbers[0].number}`);
  
  try {
    const result = await vapiRequest('POST', '/call/phone', callData);
    
    if (result.id) {
      console.log(`\n✅ Call initiated successfully!`);
      console.log(`   Call ID: ${result.id}`);
      console.log(`   Status: ${result.status}`);
      console.log(`\nℹ️  Track this call:`);
      console.log(`   node get-call.js --id ${result.id}`);
      console.log(`   Dashboard: https://dashboard.vapi.ai/calls/${result.id}`);
      
      // Save call ID for easy reference
      const callLogPath = path.join(process.env.HOME, '.openclaw', 'workspace', 'calls.log');
      fs.appendFileSync(callLogPath, `${new Date().toISOString()} | ${result.id} | ${phoneNumber} | ${args['agent-id']}\n`);
    } else {
      console.error(`\n❌ Call failed:`, result);
    }
  } catch (error) {
    console.error(`\n❌ Error making call:`, error.message);
    process.exit(1);
  }
}

makeCall();
