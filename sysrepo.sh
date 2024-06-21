#!/bin/bash

#####################################################################################

# Script Name	:	sysrepo
# Description	:	Script to monitor critical system parameters
# Args		:
# Author	:	Kevin Wehrli
# Email		:	kevin.wehrli@emilfrey.ch

#####################################################################################

clear

# FUNCTION -> Abstand zwischen Abschnitten:
spacer() {
	echo " " >> $file
echo "########################################" >> $file
echo " " >> $file
}

empty() {
echo " " >> $file
}

divider() {
echo " ---------------------------------------" >> $file
}

# VARIABLE -> Datum + Uhrzeit abrufen:
DATE=$(date +%d.%m.%Y)
TIME=$(date +%H:%M)

# Dateipfad in einer Variable speichern:
file=/tmp/systemreport_$DATE.log

# Datei erstellen oder überschreiben:
echo " " > $file

# Titel + Trennlinie:
cat <<TITLE >> $file
########################################
###                                  ###
###             CAPTEST              ###
###                -                 ###
###            $DATE            ###
###              $TIME               ###
###                                  ###
########################################
TITLE

empty

# Überwachung Speicherplatzbelegung (df -h /):
echo "         BELEGUNG SPEICHERPLATZ:" >> $file
empty
df -h / | awk 'NR==1 {print "       " $2 " | " $3 " | " $4 " | " $5} NR==2 {print "        " $2 " |  " $3 " |  " $4 "  | " $5}' >> $file

spacer

# Überwachung Webservices (WS = Webservice / SS = Service Status):
webservices=("ascserver" "ascserver_autoi" "ascserver_capsit" "ascserver_reifenman" "ascwatchdog")

for ws in "${webservices[@]}"; do
status=$(systemctl is-active "$ws")
[ "$status" == "active"] && echo " $ws.............OK" >> $file || echo " $ws.............!DOWN!" >> $file
divider
done

spacer

# Überwachung Logfiles (LP = Log Path / LN = Log Name / LN?S = Log Name Short / LC = Log Count):
LP="/var/log/asc"
LN1="ascserver_capsit*"
LN2="ascserver_pl6565*"
LN1S="capsit.log"
LN2S="pl6565"
LC1=$(find $LP -name "$LN1" | wc -l)
LC2=$(find $LP -name "$LN2" | wc -l)

echo "               LOGFILES:" >> $file
empty
echo " $LN1S......................$LC1 Files" >> $file
ls -ahlS ${LP}/$LN1 | head -3 | awk '{print "  - " $5 " | " $6 " " $7 " | " substr($9, index($9, "capsit.log"))}' >> $file
echo "    ..." >> $file
divider
echo " $LN2S..........................$LC2 Files" >> $file
ls -ahlS ${LP}/$LN2 | head -3 | awk '{print "  - " $5 " | " $6 " " $7 " | " substr($9, index($9, "pl6565"))}' >> $file
echo "    ..." >> $file

spacer

# File nach Durchführung Script anzeigen:
cat $file

# File per Mail versenden:
SERVER="CAPTEST"
COUNTR="CH"
mail_content=$(cat $file)

html_content="<html><body><pre style=\"font-family: 'Lucida Console', 'Consolas', 'Courier New', monospace;\">$mail_content</pre></body></html>"

echo -e "Subject: $SERVER $COUNTR - $DATE | $TIME\nContent-Type: text/html\n\n$html_content" | msmtp -a default kevin.wehrli@emilfrey.ch 
