#!/usr/bin/env node

const { execSync, spawn } = require('child_process');
const path = require('path');

const PORT = process.env.PORT || 3002;

function showHelp() {
  console.log(`
🔍 AI Visual Code Review CLI

Usage: ai-review [command] [options]

Commands:
  start, serve, s     Start the visual review server (default)
  quick, q           Generate quick AI review markdown
  help, h            Show this help message

Options:
  --port, -p         Port number (default: 3002)
  --open, -o         Open browser automatically

Examples:
  ai-review                    # Start visual server
  ai-review start --port 3003  # Start on custom port
  ai-review quick              # Quick markdown generation
  ai-review --help             # Show help

Repository: https://github.com/PrakharMNNIT/ai-visual-code-review
  `);
}

function checkGitRepo() {
  try {
    execSync('git rev-parse --git-dir', { stdio: 'ignore' });
    return true;
  } catch (error) {
    console.error('❌ Error: Not a git repository');
    console.log('💡 Please run this command inside a git repository');
    console.log('   Initialize with: git init');
    return false;
  }
}

function startServer(port = PORT, openBrowser = false) {
  console.log('🔍 Starting AI Visual Code Review Server...');
  console.log(`📁 Working directory: ${process.cwd()}`);

  if (!checkGitRepo()) {
    process.exit(1);
  }

  const serverPath = path.join(__dirname, '..', 'server.js');

  // Set environment variable for port
  process.env.PORT = port;

  // Start the server
  const serverProcess = spawn('node', [serverPath], {
    stdio: 'inherit',
    env: { ...process.env, PORT: port }
  });

  // Open browser if requested
  if (openBrowser) {
    setTimeout(() => {
      const url = `http://localhost:${port}`;
      console.log(`\n🌐 Opening browser: ${url}`);

      const start = (process.platform == 'darwin'? 'open': process.platform == 'win32'? 'start': 'xdg-open');
      execSync(`${start} ${url}`, { stdio: 'ignore' }).catch(() => {
        console.log('💡 Could not open browser automatically');
      });
    }, 2000);
  }

  // Handle process termination
  process.on('SIGINT', () => {
    console.log('\n👋 Shutting down AI Visual Code Review Server...');
    serverProcess.kill('SIGINT');
    process.exit(0);
  });

  serverProcess.on('exit', (code) => {
    if (code !== 0) {
      console.error(`❌ Server exited with code ${code}`);
    }
    process.exit(code);
  });
}

function quickReview() {
  console.log('📝 Generating quick AI review...');

  if (!checkGitRepo()) {
    process.exit(1);
  }

  const scriptPath = path.join(__dirname, '..', 'scripts', 'quick-ai-review.sh');

  try {
    execSync(`chmod +x "${scriptPath}"`, { stdio: 'ignore' });
    execSync(`"${scriptPath}"`, { stdio: 'inherit', cwd: process.cwd() });
  } catch (error) {
    console.error('❌ Quick review generation failed');
    console.error(error.message);
    process.exit(1);
  }
}

// Parse command line arguments
const args = process.argv.slice(2);
let command = 'start';
let port = PORT;
let openBrowser = false;

// Parse arguments
for (let i = 0; i < args.length; i++) {
  const arg = args[i];

  switch (arg) {
    case 'help':
    case 'h':
    case '--help':
    case '-h':
      showHelp();
      process.exit(0);
      break;

    case 'start':
    case 'serve':
    case 's':
      command = 'start';
      break;

    case 'quick':
    case 'q':
      command = 'quick';
      break;

    case '--port':
    case '-p':
      if (i + 1 < args.length) {
        port = parseInt(args[i + 1]);
        i++; // Skip next argument
        if (isNaN(port) || port < 1 || port > 65535) {
          console.error('❌ Invalid port number');
          process.exit(1);
        }
      }
      break;

    case '--open':
    case '-o':
      openBrowser = true;
      break;

    default:
      if (arg.startsWith('-')) {
        console.error(`❌ Unknown option: ${arg}`);
        console.log('💡 Use --help for usage information');
        process.exit(1);
      }
      // If no command specified yet, treat as command
      if (command === 'start' && i === 0) {
        command = arg;
      }
      break;
  }
}

// Execute command
switch (command) {
  case 'start':
  case 'serve':
  case 's':
    startServer(port, openBrowser);
    break;

  case 'quick':
  case 'q':
    quickReview();
    break;

  default:
    console.error(`❌ Unknown command: ${command}`);
    console.log('💡 Use --help for usage information');
    process.exit(1);
}
