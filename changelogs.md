# Changelogs


## Next release

## 0.3.2 - 2016-10-29

* **BUG** - open_timeout parameter wasnt defaulted when using veye as library; [#52](https://github.com/versioneye/veye/issues/52)

* **BUG** -markdown formatter missed license information after refactoring; [#53](https://github.com/versioneye/veye/issues/53)

## 0.3.1 - 2016-09-05

* **FIX** - function signature mismatch in the `project check` command
* **FIX** - function signature mismatch in the `github delete` command

## 0.3.0 - 2016-09-02

* add vulnerability field for product details [#6](https://github.com/versioneye/veye/issues/6)
* **BREAKING** - refactored the `veye info` command, which expect that a product language is explicitly specified with `--language` flag and allows,
new command looks like this now `bundle exec bin/veye info --language=PHP --version='3.0.1' symfony/symfony --format=table`
* **BREAKING** - renamed the `products` command to `package`
* **BREAKING** - moved `info` command under the `package` command
* **BREAKING** - refactored others subcommands of the `package` to match with the `info` command.
* **BREAKING** - project commands accept --all as flag, but not attribute with value
* add `--private` flag for the `project check` command, possible to mark project visibility when checking project file [#25](https://github.com/versioneye/veye/issues/25)
* add `--temp` flag for the the `project check` command, possible to create temporary projects;
* add `--all`, `--major`, `--minor`, `--patch` flag for all the __projects__ command, including the check command; those flags allow filter outdated dependencies by SemVer scopes; [#23](https://github.com/versioneye/veye/issues/23)
* project dependencies are now sorted by `upgrade_complexity_heuristics`, which heuristic metric that gives an rough estimation how difficult upgrading to a current version will be;
* all the output of `project` commands include now the `upgrade_complexity_heuristics`
* add `merge` and `unmerge` subcommands under the `projects` command, which allows to attach child project to the parent_project. [#30](https://github.com/versioneye/veye/issues/30)



## 0.2.1 - 2016-03-15

* fix check command, it used old argument orders;
* fix saving project_id into `veye.json` after API uses only id-key;
* remove redundant dependency - contracts;
* update rake from 11.1.0 to 11.1.1

## 0.2

* fixed dependency sorting - it show outdated dependencies first;
* fixed projects which used old API project_key;
* fixed parameter inconsistencies for `check`, `licenses` commands;
* updated dependencies;
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
