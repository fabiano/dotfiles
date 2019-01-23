module.exports = {
  config: {
    copyOnSelect: true,
    env: {
      HYPER: "1"
    },
    fontSize: 18,
    fontFamily: '"Fira Code", "Droid Sans Mono", "Courier New", monospace',
    shell: "C:\\Program Files\\PowerShell\\6\\pwsh.exe",
    shellArgs: [],
    scrollback: 5000,
    windowSize: [1500, 900],
  },

  keymaps: {
    "editor:movePreviousWord": "",
    "editor:moveNextWord": "",
  },

  plugins: ["hyper-snazzy"],
};
