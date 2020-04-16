# COVID-19 TRACKER

![Polybar use](https://github.com/Chermas/Covid19_tracker/blob/master/polycorona.png)

## Synopsis
This is a script that can be used to print the current confirmed cases and deaths of the new Coronavirus.

This script was made having Polybar in mind, however because it just prints out the numbers and icons, it probably works fine with other bars.

## Features
It prints out the current most recent numbers of confirmed cases and deaths of COVID-19 for either the World, or a specific country.

There is also an `extra` option which includes the first feature alongside:
- New confirmed cases and deaths for the given argument in the current date (World or country)
- Trend of daily new confirmed cases given a 7 day rolling window, shown with an upwards or downwards arrow (World or country)

## Dependencies
- `jq`
- `curl`
- `java`
- `Font-Awesome`

## Installation
Clone this repository into a folder of your choice:

`git clone https://github.com/Chermas/Covid19_tracker.git`

Then give permission to execute `corona.sh` using for example `chmod`

After that change `$PATH_TO_REPOSITORY` inside `corona.sh` to the path you cloned your repository in.

In `polybar_examples` change the path to where your `corona.sh` script is and configure it as you would with your other modules.

`exec = /path/to/repository/.corona.sh`

## Usage
The scripts is made to be run with 2 possible arguments:
- Country
- Extra

The first argument specifies which country you want data from. Should be written in lowercase or can be its  ISO 3166-1 alpha-2 code also in lowercase ([here is a list of the ISO codes](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes))

Using only the first argument will print:
- Current confirmed cases | deaths


The second argument specifies whether the extra information should be shown

**(To get extra info for World, the arguments should be `world extra`)**

**If no argument is given, the script defaults to printing world info without extra**

**Examples of use**

![Examples of use](https://github.com/Chermas/Covid19_tracker/blob/master/coronatest.png)

### API-endpoints

*If errors appear theres is a good chance the reason is because the API is down or not sending data*

(https://corona-stats.online/) For stats [Documentation](https://corona-stats.online/help)

(https://corona-api.com/) For trend [Documentation](https://about-corona.net/documentation)

*This being my first kind of project, any suggestions for improvement, feedback or constructive critiscism would do no harm :)*
