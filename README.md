# sample-shopify-add-to-cart

## Overview
This is an example 
[Capybara](https://github.com/teamcapybara/capybara)-[RSpec](http://rspec.info/)-[Ruby](https://www.ruby-lang.org)
implementation of a functional browser-based acceptance test against a Shopify storefront
and its associated Shopify Admin API.

Specifically, this test demonstrates that a new product can be created in the Shopify
storefront and added to the Shopping Cart.  The product is created using the Shopify
Admin API.

Note that this implementation is based upon the concept of *the simplest thing that
might work* and should most likely be refactored if it is extended like adding 
more scenarios (tests).  It is also aimed at those readers not as familiar with
Ruby conventions (e.g. file locations and explicit `require_relative`.)

### Run Locally or in Containers
This project can be run locally or fully in containers using Docker.

#### Caveat
Although this project can be run locally, with the move of `bundler` and particularly
`nokogiri` to platform-specific gems, running in Docker is highly recommended.
Otherwise, a local `bundle install` may be needed to install the proper 
platform-specific dependencies.  This may require the removal of the current
`Gemfile.lock` first, which would install the latest version of the gems and
introduce breaking changes.

### Contents of this Framework
This framework contains support for...
* Local or fully containerized execution
* Using Selenium Standalone containers eliminating the need for locally installed browsers or drivers
* Multiple local browsers with automatic driver management


## Required Environment Variables
Environment variables are used to specify the target Shopify Storefront and its
secrets, specifically the private app API key and private app password (secret).  

**These environment variables must be set before running the tests...**
* `SHOP_NAME` - example: `SHOP_NAME=my-awesome-threads`
* `ADMIN_API_KEY` - example: `ADMIN_API_KEY=xxxxxxxxxxxxxxxxx`
* `ADMIN_API_PASSWORD` - example: `ADMIN_API_PASSWORD=yyyyyyyyyyyyy`
* `ADMIN_API_VERSION` - example: `ADMIN_API_VERSION=2021-07`


## To Run the Automated Tests in Docker
The tests in this project can be run be run fully in Docker
assuming that Docker is installed and running.  This will build
a docker image of this project and execute the tests against
a Selenium Standalone container.

### Caveat
As part of the (deployment) image build, linting (`rubocop`) and
a static security scan (`bundler-audit`) is performed. If either
of these checks fails, the image will fail to build.  These issues
would need to be addressed (e.g. using the Container-based Development Environment) before a deployable image can be built.

### Prerequisites
You must have docker installed and running on your local machine.

### To Run Fully in Docker
1. Ensure Docker is running
2. Set the required environment variables listed previously
   (e.g on the command line) before the docker-compose command
3. Run the project `docker-compose.yml` file with the
   `docker-compose.seleniumchrome.yml` file (this runs using the Chrome
   standalone container)
```
docker-compose -f docker-compose.yml -f docker-compose.seleniumchrome.yml up
```

#### To Run Using the Firefox Standalone Container
3. Run the project docker-compose.yml file (this runs using the Firefox
   standalone container
```
docker-compose -f docker-compose.yml -f docker-compose.seleniumfirefox.yml up
```

## To Run the Automated Tests Locally
The tests in this project can be run locally either with...
* Local browsers (requires the browsers to be installed)
* Selenium Standalone containers (requires the containers to be running in Docker)

The tests can be run either directly by the RSpec runner or by the
supplied `Rakefile`.

**Be sure to set the required environment variables listed previously
(e.g on the command line) before funning the command to run the tests**

### To Run Using Rake
When running the tests using Rake, the tests are run in
parallel **unless** the Safari browser is chosen.

To run the automated tests using Rake, execute...  
*browser-command-line-arguments* `bundle exec rake`

* To run using the default ":selenium" browser (Firefox), execute...  
`bundle exec rake`

### To Run Using RSpec
When running the tests using RSpec, the tests are run sequentially.

To run the automated tests using RSpec, execute...  
*browser-command-line-arguments* `bundle exec rspec`

* To run using the default ":selenium" browser (Firefox), execute...  
`bundle exec rspec`

### Browser Command Line Arguments
Environment variables are used to specify the browser type and 
if present, the remote browser URL.  If no remote browser URL
is specified, a local browser is assumed.

#### Specify Remote Browser (Container) URL
`REMOTE=`...

Specifying a Remote URL creates a remote browser of type
specified by `BROWSER` at the specified remote URL  

 **Example:**
`REMOTE='http://localhost:4444/wd/hub'`

#### Specify Browser
`BROWSER=`...

**Example:**
`BROWSER=chrome`

Currently the following (local) browsers are supported in this project:
* `chrome` - Google Chrome (requires Chrome and installs chromedriver)
* `chrome_headless` - Google Chrome run in headless mode (requires Chrome > 59 and installs chromedriver)
* `firefox` - Mozilla Firefox (requires Firefox and installs geckodriver)
* `firefox_headless` - Mozilla Firefox run in headless mode (requires Firefox and installs geckodriver)
* `phantomjs` - PhantomJS headless browser (installs PhantomJS)
* `safari` - Apple Safari (requires Safari)

### To Run Using the Selenium Standalone Debug Containers
These tests can be run using the Selenium Standalone Debug containers for both
Chrome and Firefox.  These *debug* containers run a VNC server that allow you to see
the tests running in the browser in that container.  These Selenium Standalone Debug containers
must be running on the default port of `4444`.

For more information on these Selenium Standalone Debug containers see https://github.com/SeleniumHQ/docker-selenium.

#### Prerequisites
You must have docker installed and running on your local machine.

To use the VNC server, you must have a VNC client on your local machine (e.g. Screen Sharing application on Mac).

**Be sure to set the required environment variables listed previously
(e.g on the command line) before funning the command to run the tests**

#### To Run Using Selenium Standalone Chrome Debug Container
1. Ensure Docker is running on your local machine
2. Run the Selenium Standalone Chrome Debug container on the default ports of 4444 and 5900 
for the VNC server  
`docker run -d -p 4444:4444 -p 5900:5900 -v /dev/shm:/dev/shm selenium/standalone-chrome-debug:latest`
3. Wait for the Selenium Standalone Chrome Debug container to be running (e.g. 'docker ps')
4. Run the tests specifying the `REMOTE` and `BROWSER=chrome`  
`REMOTE='http://localhost:4444/wd/hub' BROWSER=chrome bundle exec rspec`

#### To Run Using Selenium Standalone Firefox Debug Container
1. Ensure Docker is running on your local machine
2. Run the Selenium Standalone Firefox Debug container on the default ports of 4444 and 5900 
for the VNC server  
`docker run -d -p 4444:4444 -p 5900:5900 -v /dev/shm:/dev/shm selenium/standalone-firefox-debug:latest`
3. Wait for the Selenium Standalone Firefox Debug container to be running (e.g. 'docker ps')
4. Run the tests specifying the `REMOTE` and `BROWSER=firefox`  
`REMOTE='http://localhost:4444/wd/hub' BROWSER=firefox bundle exec rspec`

#### To See the Tests Run Using the VNC Server
1. Connect to vnc://localhost:5900 (On Mac you can simply enter this address into a Browser)
2. When prompted for the (default) password, enter `secret`


## Requirements and Local Setup
* Running the tests using Docker or to use Selenium Standalone Containers requires Docker to be installed and running
* Tests run locally with Ruby 2.7.4
* To run the tests using a specific **local** browser requires that browser 
be installed - NOTE: chromedriver, geckodriver, and phantomjs will be
installed automatically with the gems)

### Setup If Running Locally
1. Install bundler (if not already installed for your Ruby):  
`gem install bundler`
2. Install gems (from project root):  
`bundle`

## Development
Due to bundler moving to platform-specific `bundle install`/`Gemfile.lock`,
specifically `nokogiri`, **updates to be committed to this project must be made
within the container-based (Docker) development environment**, especially any
gem updates.

The supplied basic, container-based development environment includes
`vim` and `git`.

Running the project locally should be reserved for triage and exploration.

### To Develop Using the Container-based Development Environment
To develop using the supplied container-based development environment...
1. Build the development environment image specifying the `devenv` build
   stage as the target and supplying a name (tag) for the image.
```
docker build --no-cache --target devenv -t browsertests-dev .
```
2. Run the built development environment image either on its own or
in the docker-compose environment with either the Selenium Chrome
or Firefox container.  By default the development environment container
executes the `/bin/ash` shell providing a command line interface. When
running the development environment container, you must specify the path
to this project's source code.

To run the development environment on its own, use `docker run`...
```
docker run -it --rm -v $(pwd):/app browsertests-dev
```

To run the development environment in the docker-compose environment,
use the `docker-compose.dev.yml` file...

**Be sure to set the required environment variables listed previously
(e.g on the command line) before funning the `docker-compose` command**

```
IMAGE=browsertests-dev SRC=${PWD} docker-compose -f docker-compose.yml -f docker-compose.dev.yml -f docker-compose.seleniumchrome.yml run browsertests /bin/ash
```


## Additional Information
These tests use the...
* Shopify API gem: [Shopify API on github](https://github.com/Shopify/shopify_api)
* SitePrism page object gem: [SitePrism docs](http://www.rubydoc.info/gems/site_prism/index),
[SitePrism on github](https://github.com/natritmeyer/site_prism)
* Webdrivers browser driver helper gem: [Webdrivers on github](https://github.com/titusfortner/webdrivers)
* phantomjs-helper phantomjs driver helper gem: [phantomjs-helper on github](https://github.com/bergholdt/phantomjs-helper)
* Selenium Standalone Debug Containers [Selenium HQ on Github](https://github.com/SeleniumHQ/docker-selenium)

