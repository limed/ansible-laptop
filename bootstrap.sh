#!/bin/bash

# exit on command fail and error on unset variable
set -eu

echo "Installing homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Create ~/git directory"
mkdir ~/git

echo "Cloning ansible playbook into ~/git directory"
git clone git@github.com:limed/ansible-laptop.git ~/git/ansible-laptop
