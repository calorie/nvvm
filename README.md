# nvvm

[![Gem Version](https://badge.fury.io/rb/nvvm.svg)](https://badge.fury.io/rb/nvvm)
![build](https://github.com/calorie/nvvm/actions/workflows/master.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/be44dd745257c743b47d/maintainability)](https://codeclimate.com/github/calorie/nvvm/maintainability)

Neovim version manager

# Install

```sh
gem install nvvm
```

or

```sh
git clone https://github.com/calorie/nvvm.git
cd nvvm
bundle install
gem build nvvm.gemspec
gem install nvvm-[version].gem
```

# Setup

please add the following line into your ~/.bash_login etc:

```sh
test -f ~/.nvvm/etc/login && source ~/.nvvm/etc/login
```

you can set own root:

```sh
export NVVMROOT=/your/nvvm/root/path
test -f $NVVMROOT/etc/login && source $NVVMROOT/etc/login
```

# Usage

```sh
nvvm help
nvvm install [version]
nvvm install --use latest
nvvm reinstall [version]
nvvm rebuild [version]
nvvm use [version]
nvvm list
nvvm versions
nvvm uninstall [version]
nvvm update
```

after `nvvm use`, you have to reload shell:

```sh
exec $SHELL
```

# Contributing to nvvm

- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
- Fork the project.
- Start a feature/bugfix branch.
- Commit and push until you are happy with your contribution.
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

# Copyright

Copyright (c) 2017 Yu Shigetani. See LICENSE.txt for further details.
