# Veye

[VersionEye](http://www.versioneye.com/) is a cross-platform search engine and crowdsourcing app for open source software libraries. 
 * Take advantage of the extended search to find any library you look for. 
 * Follow and track your favorite software packages
 * Leave comments and add additional meta information to the libraries to improve the quality of the data. 
 * Contribute to this crowdsourcing project to make the world a better place for software developers.


**veye** is commandline tool to make all this available on command-line and manipulate results with awesome tools and scripts. 

![Main help](https://www.dropbox.com/s/ffvpzupa3rvc3vq/cli_start_page.png)


### Setup

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
  $> bundle build veye-0.0.1.gem
  $> veye help
  $> veye ping
  ```

###### Set up default configuration

  ```bash
  $> veye initconfig
  ```

# Basic usage


### Check service 

 ```bash
   $> veye ping
   VersionEye is: up
 ```

### Search packages 

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
 ```

###### Use result paging

  ```bash
    $> veye search junit --page 2
    $> veye search junit --page-number=2
  ```

###### Use different output format

  **pretty print** - human readable output
 
  ```bash
    $> veye search json --format=pretty
  ```
 
  ![Pretty format](https://dl-web.dropbox.com/get/versioneye_video/veye_cli/search_format_pretty.png?w=0991bcd0)
 
 **csv** - to pipeline output to [awk](http://www.gnu.org/software/gawk/manual/gawk.html)
 
 ```bash
  $> veye search json --format=csv
 ```

 ![CSV format](https://dl-web.dropbox.com/get/versioneye_video/veye_cli/search_format_csv.png?w=778a61cf)

 **json** - for manipulating results with [jq](http://stedolan.github.com/jq/) . 
 Check out our jq recipes in [wiki](https://github.com/versioneye/veye/wiki/jq-recipes) .
 
 
 ```bash
  $> veye search json --format=json
 ```
 
 ![Json format](https://dl-web.dropbox.com/get/versioneye_video/veye_cli/search_format_json.png?w=9495485e)
 
 **table**
 
 ```bash
  $> veye search json --format=table
 ```
 ![Table output](https://dl-web.dropbox.com/get/versioneye_video/veye_cli/search_format_table.png?w=302b736f)
 

###### Empty response

There will be situation, when [VersionEye](http://versioneye.com) dont have information about your search, then you will see similar response on commandline:

  ```
  No results for 'json' with given parameters: 
  {:q=>"json", :lang=>"python", :page=>1}
  ```

### Package information

It supports also `--format` flag with same values.

  ```
    $> veye info junit/junit
    Asking information about: junit/junit
  ```
  
  ![Pretty print](https://dl-web.dropbox.com/get/versioneye_video/veye_cli/info_format_pretty.png?w=09fdfbf6)
  
