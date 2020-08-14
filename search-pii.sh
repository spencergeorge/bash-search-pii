#!/bin/bash

# SET REGEX SEARCH STATEMENTS

# Credit cards. Alt: \b\d{13,16}\b
STR_REGEX_CC="\b([0-9]{4,6}[ -]?){4,5}\b"

# Phone numbers
STR_REGEX_PHONE_USCA="\b1?\W*([2-9][0-8][0-9])\W*([2-9][0-9]{2})\W*([0-9]{4})(\se?x?t?(\d*))?\b"
STR_REGEX_PHONE_INT="\b\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}\b"

# Social Security numbers
#STR_REGEX_SSN="\b(?!000)(?!666)(?<SSN3>[0-6]\d{2}|7(?:[0-6]\d|7[012]))([- ]?)(?!00)(?<SSN2>\d\d)\1(?!0000)(?<SSN4>\d{4})\b"
STR_REGEX_SSN="\b[0-9]{3}[ -]?[0-9]{2}[ -]?[0-9]{4}\b"

# Email
STR_REGEX_EMAIL="\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b"

F_PII=$(mktemp results_pii.XXX)
echo $F_PII
# Find ASCII files
for file in $(find / | xargs file -F " " | grep text | cut -d " " -f 1)
do
        if [[ $file =~ /usr/share/.+ ]]; then
                continue
        elif [[ $file =~ /usr/lib/.+ ]]; then
                continue
        elif [[ $file =~ /proc/.+ ]]; then
                continue
        elif [[ $file =~ /sys/.+ ]]; then
                continue
        elif [[ $file =~ /usr/.+idl$ ]]; then
                continue
        elif [[ $file =~ /usr/.+page$ ]]; then
                continue
        elif [[ $file =~ /usr/x86_64-w64-mingw32/.+ ]]; then
                continue
        elif [[ $file =~ /usr/lib/x86_64-linux-gnu/.+ ]]; then
                continue
        elif [[ $file =~ .+pm$ ]]; then
                continue
        elif [[ $file =~ /usr/.+py$ ]]; then
                continue
        elif [[ $file =~ .+info$ ]]; then
                continue
        elif [[ $file =~ .h$ ]]; then
                continue
        elif [[ $file =~ .pem$ ]]; then
                continue
	elif [[ $(cat $file | egrep -o "$STR_REGEX_CC") ]]; then
                printf "cc\t${file}\n" >> $F_PII
        elif [[ $(cat $file | egrep -o "$STR_REGEX_PHONE_USCA") ]]; then
                printf "p-usca\t${file}\n" >> $F_PII
        elif [[ $(cat $file | egrep -o "$STR_REGEX_PHONE_INT") ]]; then
                printf "p-int\t${file}\n" >> $F_PII
        elif [[ $(cat $file | egrep -o "$STR_REGEX_SSN") ]]; then
                printf "ssn\t${file}\n" >> $F_PII
        elif [[ $(cat $file | egrep -o "$STR_REGEX_EMAIL") ]]; then
                printf "email\t${file}\n" >> $F_PII
        fi
done

