#!/bin/bash

COUNTRY=$1
EXTRA=$2

######################################################
################	PATH TO REPOSITORY	##############
######################################################
PATH_TO_REPOSITORY=/path/to/repository

declare -a increases

if [ "$COUNTRY" = "world" ] || [ -z "$COUNTRY" ]
then
	COUNTRY="gm"
fi

URL="https://corona-stats.online/${COUNTRY}?source=2&format=json"
RES=$(curl -sf "$URL")

COUNTRY_TOTAL=$(jq ".data[0].cases" <<< $RES)
COUNTRY_DEATH=$(jq ".data[0].deaths" <<< $RES)
COUNTRY_DAILY_TOTAL=$(jq ".data[0].todayCases" <<< $RES)
COUNTRY_DAILY_DEATH=$(jq ".data[0].todayDeaths" <<< $RES)
COUNTRY_ID=$(jq ".data[0].countryInfo.iso2" <<< $RES)

TOTAL=$(jq ".worldStats.cases" <<< $RES)
DEATH=$(jq ".worldStats.deaths" <<< $RES)
DAILY_TOTAL=$(jq ".worldStats.todayCases" <<< $RES)
DAILY_DEATH=$(jq ".worldStats.todayDeaths" <<< $RES)

if [ "$COUNTRY" = "gm" ]
then
	COUNTRY=""
fi

#Check which API to get for trend
if [ -z "$COUNTRY" ]
then
	URL_TIMELINE="https://corona-api.com/timeline"
else
	URL_TIMELINE="https://corona-api.com/countries/${COUNTRY_ID//\"}"
fi

RES_TIME=$(curl -sf "$URL_TIMELINE")

print_stats(){
	#Stats for total cases and deaths for country
	if [ -n "$COUNTRY" ] && [ -z "$EXTRA" ]
	then
		echo "${COUNTRY_ID//\"/}:  $COUNTRY_TOTAL |  $COUNTRY_DEATH" | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1.\2=g;t L'

	#Stats for new cases and new deaths for country

	elif [ -n "$COUNTRY" ] && [ "$EXTRA" = "extra" ]
	then
		echo "${COUNTRY_ID//\"/}:  $COUNTRY_TOTAL + $COUNTRY_DAILY_TOTAL $TREND |  $COUNTRY_DEATH + $COUNTRY_DAILY_DEATH" | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1.\2=g;t L'

	#Stats for new cases and new deaths worldwide	

	elif [ -z "$COUNTRY" ] && [ -z "$EXTRA" ]
	then
		echo " $TOTAL |  $DEATH" | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1.\2=g;t L'

	#Default is total cases and deaths worldwide if no arg given	
	elif [ -z "$COUNTRY" ] && [ "$EXTRA" = "extra" ]
	then	
		echo " $TOTAL + $DAILY_TOTAL $TREND |  $DEATH + $DAILY_DEATH" | sed -r ':L;s=\b([0-9]+)([0-9]{3})\b=\1.\2=g;t L'
	fi
}

compute_increase(){
	NEW=0
	OLD=0
	DIF=0
	for i in {1..8}
	do
		if [ -z "$COUNTRY" ]
		then
			NEW=$(jq ".data[$i].confirmed" <<< $RES_TIME)
			OLD=$(jq ".data[$(( i+1 ))].confirmed" <<< $RES_TIME)
			DIF=$(( NEW - OLD ))
		else
			NEW=$(jq ".data.timeline[$i].confirmed" <<< $RES_TIME)
			OLD=$(jq ".data.timeline[$(( i+1 ))].confirmed" <<< $RES_TIME)
			DIF=$(( NEW - OLD ))
		fi

	INDEX=$((i - 1))
	#echo "INDEX:" $INDEX
	increases[$INDEX]=$(( (DIF * 100) / OLD ))
	
	done
}

if [ -n "$EXTRA" ]
then
compute_increase
TREND="$(java -jar ${PATH_TO_REPOSITORY}/trend.jar ${increases[@]} 2>&1 )"
fi

if [[ $TREND == 1 ]]
then
	TREND=
elif [[  $TREND == 0 ]]
then
	TREND=
fi

print_stats
