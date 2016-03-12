# Changelogs

## 0.2

* updated dependencies
* add api_keys for packages api;
* breaking changes in `check` command - it tracks all supported project files in the folder
* add `veye.json` file to keep and manage a project specific configurations
* fixed licenses field in project output
* add Settings class to manage `veye.json` file


## 0.1

* first stable release - no new functionalities
* all commands' have tests
* refactored API calls out of commands
* moved API into own namespace
* made API accessible from other projects
* fixed SSL issue;
* removed SSL generatation
* added Rubocop and removed biggest code smells
* github import supports now file and branch parameters
* fixed bugs in presentations when fields are nil
* updated dependencies


## 0.0.9

* added references endpoint
* updated docs
* added OSS license


## 0.0.8

* added timeout opts
* cleanups

## 0.0.7

* added commands to work with Github repositories. 
* big view refactoring


## 0.0.6

first usable gem

* no key checking for `ping` and `search` command (contributed by Richard Metzler)
* seemless SSL key generation - no cmd-line hack anymore
* command `project list` shows now licence information
* `project` command supports now markdown format. (contributed by Richard Metzler)
* added helper method `format_supported?` to check output format is supported.
* renamed licence command to `license`
* `ping`, `search` can now execut without identification
* 

#### Bug fixes

* [issue #15 - SSL issues ](https://github.com/versioneye/veye/issues/15)
* [issue #12 - Table format doesn't show outdated:true](https://github.com/versioneye/veye/issues/12)  


Big thanks all contibutors:

* [Richard Metzler](https://github.com/rmetzler)

## 0.0.5

fix release

## 0.0.4

fix release

* added automatic SSL generation
* updated dependencies


## 0.0.3

fix release

* added command `change_apikey`


## 0.0.2

experimental gem

* refactored to use newer API version V2.
* added SSL support
* added external config file
* added support to override global options on commandline
* added `update` command

## 0.0.1

first experimental release

* added rest-client
* supports VersionEye only API version V1, over plain http.
* added 4 different output formats: csv, json, pretty, table
* added pagination helpers
