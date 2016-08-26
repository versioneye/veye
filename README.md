# Veye

[![Dependency Status](https://www.versioneye.com/user/projects/57c0303c939fc600508e8b9a/badge.svg?style=flat-square)](https://www.versioneye.com/user/projects/57c0303c939fc600508e8b9a)
[![Join the chat at https://gitter.im/versioneye/veye](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/versioneye/veye?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


**veye** is a command line tool for [VersionEye](https://www.versioneye.com/). It is a wrapper around the [VersionEye API](https://www.versioneye.com/api), implemented in Ruby. The tool allows you to write scripts for continuous updating and due diligence. 

Most endpoints require an API key, which you can get [here](https://www.versioneye.com/settings/api) and i recommend you to use an organization API-key.

[VersionEye](https://www.versioneye.com/) is a cross-platform search engine and crowdsourcing app for opensource software libraries.

 * Take advantage of the extended search to find any library you look for.
 * Follow and track your favorite software packages via RSS feed.
 * Leave comments and add additional meta information to the libraries to improve the quality of the data.
 * Contribute to this crowdsourcing project to make the world a better place for software developers.

![Main help](http://dl.dropbox.com/u/19578784/versioneye/cli_start_page.png)


## Getting started with RubyGems

```
  $> gem install veye
  $> veye
  $> veye initconfig
  $> veye change_key a124423233
```

## Getting started for developers

###### Download source

 ```bash
  $> git clone https://github.com/versioneye/veye.git
  $> cd veye
 ```

###### Execute the CLI-tool without installing
 ```
  $> bundle
  $> bundle exec bin/veye ping
 ```

###### Or build Gem file and install it as global command

  ```
  $> gem build veye.gemspec
  $> veye help
  $> veye ping
  ```

## Initial configuration

The tool will raise an exception if the configuration file is missing. The Veye uses the configuration file to keep settings and your API Key.

#### create config file

  ```
  $> veye initconfig
  # it creates configuration file for VersionEye CLI
  $> cat ~/.veye.rc
  :api_key: <add your key>
  :server: 127.0.0.1
  :port: "3000"
  ....
  ```

#### initialize API key

Please visit [your settings page](https://www.versioneye.com/settings/api) on VersionEye for the API key and then use command `veye change_key` to save your api key.

```
 $> veye change_key abj23j2bj33k14
 Success: your key is now saved.
```

# Basic usage

```bash
$> veye ping
   pong

$> veye search json --lang=r,php --page=2

#you can cancel pagination with --no-pagination argument
$> veye search junit --page 3 --no-pagination

$> veye info --language=PHP --version='3.0.1' symfony/symfony --format=table
```

## Output formats

All commands support output format flag, that allows you change layout between human friendly display and machine readable formats.

#### pretty print

Prettyprint is human readable output with colors to highlight an most important piece of information on a screen.
It's designed after other ruby command-line tools.

```bash
  $> veye search json --format=pretty
```

  ![Pretty format](http://dl.dropbox.com/u/19578784/versioneye/search_pretty.png)

#### CSV
 CSV is good format for unix command line tools such as [awk](http://www.gnu.org/software/gawk/manual/gawk.html)

 ```bash
  $> veye search json --format=csv
 ```

 ![CSV format](http://dl.dropbox.com/u/19578784/versioneye/search_csv.png)

#### JSON

 JSON output is great, if you're going to manipulate output results with [jq](http://stedolan.github.com/jq/).
 Check out our jq recipes in [wiki](https://github.com/versioneye/veye/wiki/jq-recipes) .


 ```bash
  $> veye search json --format=json
 ```

 ![Json format](http://dl.dropbox.com/u/19578784/versioneye/search_json.png)

#### Table view
It's shows results as a big Excel sheet and works best on bigger screens.

 ```bash
  $> veye search json --format=table
 ```

 ![Table output](http://dl.dropbox.com/u/19578784/versioneye/search_table.png)


#### Markdown

This flag formats your results in markdown.

Here's dependencies of demo project formatted as [markdown table](https://gist.github.com/timgluz/6857422).

```
$> veye projects show rubygem_gemfile_lock_1 --format=md
$> veye projects show rubygem_gemfile_lock_1 --format=md > dependencies.md

```

#### Empty response

There will be situation, when [VersionEye](http://versioneye.com) dont have information about your search, then you will see similar response on commandline:

  ```
  No results for 'json' with given parameters:
  {:q=>"json", :lang=>"python", :page=>1}
  ```
#### Extra information

Commands that show list of items, always show pagination information by default. You can always cancel this information by using `no-pagination` flag and feed data into unix tools.

```
$> veye search junit --page 3 --no-pagination
```

## Global options

You can override your default global options by adding proper keyword and value.
For example to overriding a port number:

```
$> veye --port=4567 search json --lang=php,nodejs
```

##### Timeouts

The best place to manage timeouts for a single run is to use commandline flags.  

```
$> veye --timeout=100 --open_timeout=10 ping
```

**NB!** unit of timeout is a second and it's doesnt accepts milliseconds. Therefore smallest timeout is 1second and you can use -1 as infinite timeout.

If you want to change timeout settings permanently, then you shall change timeout values in your `.veye.rc` file.

#### Updating options file

There may be a situation when you need to update/re-write saved config file. Then you you can use `veye initconfig --force` command to re-write already existing configuration file.


## Contributing

All contributions are welcome - comments, new ideas, help with documentation & help with features;

#### Running tests


```
$> rm test/fixtures/vcr_cassettes/* #if needed
$> VEYE_API_KEY=<YOUR_API_KEY> rake test
$> rake test TEST=test/file_you_changed.rb
```

#### Rubocop

```
$> rubocop lib/your_file.rb
```

## Further documentation

More documentation can be found in the [Veye wiki](https://github.com/versioneye/veye/wiki). 

## License
The MIT License (MIT)

Copyright: (c) 2016 **VersionEye GmbH**


[MIT licence](http://choosealicense.com/licenses/mit/)
