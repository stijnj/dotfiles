module.exports = {
  updateChannel: "canary",
  config: {
    // default font size in pixels for all tabs
    fontSize: 14,
    windowSize: [1080, 720],
    fontFamily: '"Iosevka Extended", "VictorMono Nerd Font Mono", "Comic Sans", monospace',
    cursorShape: "BLOCK",
    wickedBorder: false,
    padding: "10px",
    shell: "/bin/zsh",
    lineHeight: 1.2,
    letterSpacing: 1,
    catppuccinTheme: 'Macchiato'
  },

  plugins: [
    // 'hyperterm-cobalt2-theme'
    // "hyperterm-panda",
    'hypurr#latest'
  ],

  // in development, you can create a directory under
  // `~/.hyperterm_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  // localPlugins: ['hyperterm-cobalt2-theme'],
};