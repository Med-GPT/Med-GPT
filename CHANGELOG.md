<h1 align=center>

[Med-GPT](https://Med-GPT.github.io/) Change Log
</h1>

## Refactor Electron IPC and Main Process

### Added

- Adding a loading View.
- Added experimental starter script and test files for Electron main process and preload.
- Created a new web-page structure with CSS and HTML for better organization and styling.
- Created Vite configuration for asset handling and module resolution.
<!-- - Added a new README.md file with project description, installation instructions, and usage guidelines. -->

### Changed

- Simplified IPC channel handling in ipcMain.ts by removing unnecessary type assertions.
- Relacing the Channels class with a literal object.
- Updated main.ts to improve global variable assignments and window configuration.
- Adjusted session management and preload script handling for better clarity and performance.
- Enhanced config.ts to utilize absolute imports and added a base64 encoded string for env.base.
- Cleaned up utils.ts by commenting out unused imports and functions.
- Modified tsconfig.json to set baseUrl and paths for easier module resolution.
- Updated types.d.ts to include new global types and interfaces for better type safety.

### Fixed

- None

### Removed

- Removed unused CSS and HTML files from the www directory to streamline the project.
- Removed unnecessary comments and code snippets from various files to improve readability.
