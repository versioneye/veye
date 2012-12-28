# Veye


Commandline tool for VersionEye. This tool ables to check availability of VersionEye API, search packages on commandline and check information about package.

### Setup

 ```bash
  $> git clone https://github.com/versioneye/veye.git
  $> cd veye
  $> bundle
  $> bundle exec bin/veye ping
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

 ```ruby
 #Results
   [[0], {
          "artifact_id" => "junit",
           "group_id" => "junit",
           "language" => "Java",
               "name" => "junit",
           "prod_key" => "junit/junit",
            "version" => "4.11"
          }, ...]
 ```
 
 
* Empty response
 
  ```ruby
    No results for `json` with given parameters: {:q=>"json", :lang=>"python", :page=>1}

  ```

###### Read information of the package


  ```ruby
    $> veye info junit/junit
    Askining information about: junit/junit
    {
    "artifact_id" => "junit",
    "description" => "JUnit is a regression testing framework written by Erich Gamma and Kent Beck.
                      It is used by the developer who implements unit tests in Java.",
       "group_id" => "junit",
       "language" => "Java",
        "license" => "Common Public License Version 1.0",
           "link" => "http://mvn.carbonfive.com/nexus/content/groups/public/junit/junit/",
           "name" => "junit",
       "prod_key" => "junit/junit",
      "prod_type" => "Maven2",
        "version" => "4.11"
    }
  ```
  
Coming soon...

