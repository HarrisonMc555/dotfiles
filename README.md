# Dotfiles

Harrison McCullough's Ubuntu / macOS dotfiles.

## About this project

This is based off of "Cowboy"'s [dotfiles
setup](https://github.com/cowboy/dotfiles). If you have any questions, that
would probably be a better place to ask.

## Installation (for Harrison McCullough)

### Ubuntu

```sh
export DOTFILES_GH_USER=HarrisonMc555
export DOTFILES_GH_BRANCH=master
bash -c "$(wget -qO- https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles)" && source ~/.bashrc
```

### macOS

```sh
export DOTFILES_GH_USER=HarrisonMc555
export DOTFILES_GH_BRANCH=master
bash -c "$(curl -fsSL https://raw.github.com/$DOTFILES_GH_USER/dotfiles/$DOTFILES_GH_BRANCH/bin/dotfiles)" && source ~/.bashrc
```

## License
Copyright (c) 2019 Harrison McCullough  
Copyright (c) 2014 "Cowboy" Ben Alman  
Licensed under the MIT license.  
<http://benalman.com/about/license/>
