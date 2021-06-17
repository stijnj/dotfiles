module.exports = {
    updateChannel: 'canary',
    config: {
        // default font size in pixels for all tabs
        fontSize: 12,
        windowSize: [1080, 720],
        fontFamily: '"Fira Code", monospace',
        cursorShape: 'BLOCK',
        wickedBorder: false,
        padding: '10px',
        shell: '/bin/zsh'
    },

    plugins: [
        // 'hyperterm-cobalt2-theme'
        'hyperterm-panda'
    ],

    // in development, you can create a directory under
    // `~/.hyperterm_plugins/local/` and include it here
    // to load it and avoid it being `npm install`ed
    // localPlugins: ['hyperterm-cobalt2-theme'],
};