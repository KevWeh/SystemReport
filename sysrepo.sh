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
WS1="ascserver"
WS2="ascserver_reifenman"
SS1=$(systemctl is-active $WS1)
SS2=$(systemctl is-active $WS2)

echo "              WEBSERVICES:" >> $file
empty
[ "$SS1" == "active" ] && echo " $WS1............................OK" >> $file || echo " $WS1.........................!DOWN!" >> $file
divider
[ "$SS2" == "active" ] && echo " $WS2..................OK" >> $file || echo " $WS2...............!DOWN!" >> $file

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

Test