# Veye


Commandline tool for VersionEye. This tool ables to check availability of VersionEye API, search packages on commandline and check information about package.

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

### Basic usage


###### Check service 

 ```bash
   $> veye ping
   VersionEye is: up
 ```

###### Search packages 

* get command help

 ```bash
   $> veye search help
 ```
 
* basic package search with language filtering

 ```bash
   $> veye search junit
   $> veye search -l java
   $> veye search --language java
   $> veye search --language-name=java
 ```

* use result paging

  ```bash
    $> veye search junit --page 2
    $> veye search junit --page-number=2
  ```

* Successful response

 
 
* Empty response
 
  ```ruby
  No results for 'json' with given parameters: 
  {:q=>"json", :lang=>"python", :page=>1}
  ```

###### Read information of the package


  ```ruby
    $> veye info junit/junit
    Asking information about: junit/junit
  ```
  
