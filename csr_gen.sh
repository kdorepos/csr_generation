#!/bin/bash

# Global parameters
DIVIDINGLINE="--------------------------------------------------------------------------------"
DATE=`date +%Y%m%d`
CERTSTORE="/certStore"

# Let's get functional
lines() {
echo $DIVIDINGLINE
echo $DIVIDINGLINE
}

fresh() {
clear
lines
}

# Sayin' hey
fresh
echo "Welcome to the Certificate Signing Request Generation Script."
echo -n "Press any key to continue."
read -n 1 -s -p ""

# Asking the important questions
fresh
echo "What's your fully-qualified domain name? (i.e. server.contoso.com) "
echo ""
echo -n -e "\t--> "
read FQDN
echo $FQDN | grep -q "contoso.com"
if [ $? -eq 0 ]
        then
        echo ""
                echo -n -e "\tThanks!"
                SHORTNAME=`echo $FQDN | cut -d"." -f1` # Taking out the domain, we won't need that
                mkdir $CERTSTORE/$FQDN > /dev/null
                sleep 2
        else
                echo -n "Seems like you're missing the domain - let's try that again. "
                read FQDN
fi

# Gimme dat key
fresh
echo "Creating your private key..."
sleep 3
cd /$CERTSTORE/$FQDN
openssl genrsa -out $SHORTNAME-$DATE.key 2048 >> /dev/null

# Let's do what we came to do - generate that CSR!
openssl req -new -key $SHORTNAME-$DATE.key -out $SHORTNAME-$DATE.csr -subj "/O=U.S. Government/OU=DoD/C=US/CN=$FQDN" >> /dev/null

# Fix those perms like it's 1975
chmod -R 755 /certStore

# Get out of there
fresh
echo -n "Would you like to display your CSR so you can easily copy it your clipboard? [y/n] "
if [ ! "$CSRDISPLAY" ]; then
    read CSRDISPLAY
fi
case $CSRDISPLAY in
    [Yy])
        echo ""
        cat $CERTSTORE/$FQDN/$SHORTNAME-$DATE.csr
        echo ""
        exit 0
        ;;
    [Nn])
        echo "" > /dev/null
        ;;
    *)
        echo "C'mon, select a valid option."
        ;;
esac
fresh
echo "All done!"
sleep 2
