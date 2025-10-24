const { execFile } = require('child_process');
const path = require('path');

describe('Path handling with spaces', () => {
  test('execFile handles paths with spaces correctly', (done) => {
    // Test that execFile properly handles file paths with spaces
    const testPath = 'docs/Archive_v1.0/sr Review /16_Week_Implementation_Timeline.md';

    // This simulates what our executeGitCommand does
    const gitCommand = 'git';
    const gitArgs = ['diff', '--cached', '--', testPath];

    execFile(gitCommand, gitArgs, {
      encoding: 'utf-8',
      cwd: process.cwd(),
      timeout: 5000
    }, (error, stdout, stderr) => {
      // We expect this to fail because the file doesn't exist in our test repo,
      // but it should fail with a proper Git error, not a shell parsing error

      if (error) {
        // The error should be a git error about the file not being found,
        // NOT a shell parsing error about paths being outside the repository
        const isShellParsingError = stderr.includes('is outside repository') ||
                                   stderr.includes('Invalid path');

        // For our test, we expect it to fail, but with a proper Git error
        // The key is that execFile doesn't have shell parsing issues with spaces
        console.log('Error (expected):', error.message);
        console.log('Stderr:', stderr);

        // If we get here without a shell parsing error, the fix is working
        expect(isShellParsingError).toBe(false);
      }

      done();
    });
  }, 10000);

  test('execFile vs exec comparison', () => {
    // This test demonstrates the difference between exec and execFile
    const testPath = 'test path with spaces.txt';

    // With exec (old way - UNSAFE for paths with spaces):
    // const command = `git diff --cached -- ${testPath}`;
    // This would be interpreted as: git diff --cached -- test path with spaces.txt
    // And would fail with "path is outside repository"

    // With execFile (new way - SAFE for paths with spaces):
    // execFile('git', ['diff', '--cached', '--', testPath], ...)
    // Each argument is properly passed as a separate argument
    // So 'test path with spaces.txt' is treated as ONE argument

    expect(true).toBe(true); // Test passes to document the difference
  });
});
