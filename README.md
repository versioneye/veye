# Veye

[![Dependency Status](https://www.versioneye.com/ruby/veye/0.0.5/badge.png)](https://www.versioneye.com/ruby/veye/0.0.5)

[VersionEye](http://www.versioneye.com/) is a cross-platform search engine and crowdsourcing app for opensource software libraries. 

 * Take advantage of the extended search to find any library you look for. 
 * Follow and track your favorite software packages via RSS feed.
 * Leave comments and add additional meta information to the libraries to improve the quality of the data. 
 * Contribute to this crowdsourcing project to make the world a better place for software developers.


**veye** is commandline tool to make all this available on command-line and manipulate results with awesome tools and scripts. 

**PS:** Our _premium customers_ can also use offline search. Please send your email to `contact@versioneye.com` to get more information.

Most endpoints require the api-key, which you can get [here](https://www.versioneye.com/settings/api).

![Main help](http://dl.dropbox.com/u/19578784/versioneye/cli_start_page.png)


### Install


```
  $> gem install veye
```

### Using dev-version

###### Download source

 ```bash
  $> git clone https://github.com/versioneye/veye.git
  $> cd veye
 ```

###### Run without installing
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
 
### Initial configuration

The tool will raise exception when a configuration file is missing. The tool needs configuration file to keep user specific settings and  authorization key. 

###### create config file

  ```
  $> veye initconfig
  #it creates configuration file for VersionEye CLI
  $> cat ~/.veye.rc
  :api_key: <add your key>
  :server: 127.0.0.1
  :port: "3000"
  ....
  ```
  
###### add key

Please visit [your settings page](https://www.versioneye.com/settings/api) on VersionEye for the api-key and then use command `veye change_key` to save your api key.

```
 $> veye change_key abj23j2bj33k14
 Success: your's key is now saved.
``` 

# Basic usage


### Check service
You can use this service to check does the tool works and tests is our API accessible. This command doesnt need authorization.

 ```bash
   $> veye ping
   pong
 ```

### Search packages

This command opens window to magnificient world of software packages - VersionEye has ~ 250K software libraries and it's reachable via your commandline.

###### Get command help

 ```bash
   $> veye search help
 ```
 
###### Basic package search with language filtering

 ```bash
   $> veye search junit
   $> veye search -l java
   $> veye search --language java
   $> veye search --language-name=java
   
   #search packages for multiple languages
   $> veye search --lang=nodejs,php
 ```

###### Use result paging

  ```
    $> veye search junit --page 2
    $> veye search junit --page-number=2
    $> veye search json --lang=r,php --page=2
    
    #you can cancel pagination with --no-pagination argument
    $> veye search junit --page 3 --no-pagination
  ```

### Output formats

All commands support format-flag, that allows you change output format.

###### pretty print

Prettyprint is human readable output with colors. It's designed after other ruby command-line tools.
 
```bash
  $> veye search json --format=pretty
```
 
  ![Pretty format](https://s3-eu-west-1.amazonaws.com/veye/search_format_pretty.png)
 
###### CSV
 CSV is good format for unix command line tools as [awk](http://www.gnu.org/software/gawk/manual/gawk.html)
 
 ```bash
  $> veye search json --format=csv
 ```

 ![CSV format](https://s3-eu-west-1.amazonaws.com/veye/search_format_csv.png)

###### JSON
 
 It also supports JSON to manipulate results with [jq](http://stedolan.github.com/jq/) . 
 Check out our jq recipes in [wiki](https://github.com/versioneye/veye/wiki/jq-recipes) .
 
 
 ```bash
  $> veye search json --format=json
 ```
 
 ![Json format](https://s3-eu-west-1.amazonaws.com/veye/search_format_json.png)
 
###### Table view

A Tabular view for bigger screens. It's shows results as one Excel sheet - title and content.
  
 ```bash
  $> veye search json --format=table
 ```
 ![Table output](https://s3-eu-west-1.amazonaws.com/veye/search_format_table.png)
 

###### Markdown

This flag formats your results in markdown.
 
Here's dependencies of demo project formatted as [markdown table](https://gist.github.com/timgluz/6857422).

```

	$> veye projects show rubygem_gemfile_lock_1 --format=md
	$> veye projects show rubygem_gemfile_lock_1 --format=md > dependencies.md
```


###### Empty response

There will be situation, when [VersionEye](http://versioneye.com) dont have information about your search, then you will see similar response on commandline:

  ```
  No results for 'json' with given parameters: 
  {:q=>"json", :lang=>"python", :page=>1}
  ```
  
### Global options

You can override your default global options by adding proper keyword and value.
For example to override a number of port, when doing search:

```
  $> veye --port=4567 search json --lang=php,nodejs
```

###### Timeouts

The best place to manage timeouts for a single run is to use commandline flags.  

```
 $> veye --timeout=100 --open_timeout=10 ping
```

**NB!** unit of timeout is a second and it's doesnt accepts milliseconds. Therefore smallest timeout is 1second and you can use -1 as infinite timeout.

If you want to change timeout settings permanently, then you shall change timeout values in your `.veye.rc` file. 

###### Updating options file

There may be a situation when you need to update/re-write saved config file. Then you you can use `veye initconfig --force` command to re-write already existing configuration file.

### Package information

Ok, thats most trickiest part of our tool. You need to prepend a language of package just before product's key. For example, if you have Java package with product key junit/junit, then you have to encode this value as: `java/junit/junit`.


It supports also `--format` flag with same values.

  ```
    $> veye info java/junit/junit
    Asking information about: junit/junit
  ```
  
  ![Pretty print](https://s3-eu-west-1.amazonaws.com/veye/info_format_pretty2.png)
  

### Products 

This command has subcommands to control your personal connections with libraries.

```
	;;follow some package to add it into your RSS feed
	$> veye products follow clojure/ztellman/aleph
	$> veye products unfollow clojure/ztellman/aleph
	
	;; show the list of products in your's RSS feed
	$> veye products
```

### Check

Use `check` command to upload your project file and check the state of dependencies. **NB!** it only shows information about dependencies, if you need also project info, then please use `veye project upload` command.

```
 $> veye check test/files/Gemfile
```

### Project

The `project` command holds a multiple subcommands for working with our project files.

###### show existing projects

```
  $> veye projects list
  $> veye projects --format=table
```

###### show information of specific project

A `show` command expects a proper project_key, which you can from the list of already existing projects.

```
	$> veye projects show rubygem_gemfile_1
	$> veye projects show rubygem_gemfile_1 --format=table
```

###### upload project file

Use `upload` command to create new project. This command expects proper filepath to the file and the file is smaller than 500KB. VersionEye supports currently 8 different package managers(*Leiningen, Gem, Maven, NPM, Packagist, Pip, Setup.py, R*), Bower and Obj-C is already on pipeline.

```
  $> veye projects upload test/files/Gemfile
  $> veye projects upload test/files/maven.pom
```

###### re-upload project file for existing project

You can use `update` command to update the information of already existing project.
This command expects correct project_key and a path to file.

```
  $> veye projects update rubygem_gemfile_1 test/files/Gemfile
  $> veye projects update rubygem_gemfile_1 test/files/Gemfile --format=table
```

###### Delete project

This command removes the specified project from your project's list.

```
	$> veye projects delete rubygem_gemfile_1
	Deleted
```

###### Licences

`licence` command returns all licenses used in your project.

```
	$> veye projects licences rubygem_gemfile_1 --format=table
```


### Me

`me` command returns short overview of your profile and your current payment plan.

```
	$> veye me
``` 

###### Favorite packages

`me` command has a `favorite` subcommand, which returns all packages you're currently following.

```
 $> veye me favorites
 $> veye me favorites --page=2 --format=table
```

### Github

`Github` command includes subcommands to manage your Github repositories on VersionEye.

All subcommands expect that you had already connected your Github with your VersionEye account. Otherwise you'll get plain exception message.

##### Sync

Updates your Github data - this api's resource tries to be lazy: it pulls updates only if there's no cached repositories or Github shows there's any changes on your repositories. But you can use `--force` switch to re-import all data regardless there's any changes on your repositories. Beware this command can takes time.

```
 $> veye github sync
 $> veye github sync --force
```

###### List

`list` commands shows paginated view of your repositories.

```
 $> veye github list --format=table
```

###### Info

This command shows more detailed information.

```
 $> veye github info versioneye/veye
 $> veye github info versioneye/veye --format=table
```

###### Import

`import` command takes fullname of repository and tries to import project file from that repository.  Fullname have to include the owner and the name of repository.

By default, it tries to read project file on master branch; you can use a `--branch` flag to specify the name of branch. 

This command gives exception when you are trying to import already imported repository.


```
 $> veye github import versioneye/veye
 $> veye github import versioneye/veye --branch=dev
```


###### Delete

It removes imported project.

```
 $> veye github delete versioneye/veye
 $> veye github delete versioneye/veye --branch=dev
```

###### Search 

This command makes authorized request to the Github search api for  repositories. As authorized user, you can make up to *5000* request per hour. 

```
 $> veye github search versioneye 
 $> veye github search json --language=php --page=2 ;; filter results by language
 $> veye github search veye --user versioneye       ;; filter results by users
```
