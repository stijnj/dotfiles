# Stijn's dotfiles
## Installation
### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles`, with `~/dotfiles` as a symlink.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/stijnj/dotfiles.git && cd dotfiles && source install.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source install.sh
```

## Thanks
Everone who open sourced their dotfiles. Specially [GitHub does dotfiles](https://dotfiles.github.io/).