🔖 build(version): bump version to 1.0.4

## Problem

Previous version 1.0.3 already exists on npm registry, preventing publishing of the enhanced package with memory-bank system and CLI fixes.

## Solution

- Bumped package version from 1.0.3 to 1.0.4
- Enables npm publishing of the improved package with all recent enhancements

## Changes

- Updated version in package.json to 1.0.4

## Impact

- Allows npm publish to proceed successfully
- Users can install the latest version with:
  - Memory-bank documentation system
  - Fixed CLI command parsing (no more npx required)
  - Reduced excessive logging
  - Corrected binary paths
  - Enhanced security and development guidelines

## Technical Details

This is a patch version bump following semantic versioning:

- No breaking changes
- All improvements are backward compatible
- Maintains all existing functionality while adding enhancements

Ready for npm publishing and distribution.
