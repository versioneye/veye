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
 ```ruby
   $> veye ping
   VersionEye is: up
 ```

###### Search packages 

 ```ruby
   $> veye search junit
   [
    [0], {
        "artifact_id" => "junit",
           "group_id" => "junit",
           "language" => "Java",
               "name" => "junit",
           "prod_key" => "junit/junit",
            "version" => "4.11"
          }]
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

