#!/usr/bin/env bash

# This scripts helps you in automatically filling (and managing the data)
# for html forms (any html form, including login forms)
#
# We use a little helper script, defined by $js_helper,
# which creates a JSON-ish object that contains the form information we want
# to store. It is important that there is only one such object per file and the other(s)
# should be commented out with a #

# config examples:
# bind II = sh $XDG_CONFIG_HOME/uzbl/scripts/formfiller.sh load
# bind In = sh $XDG_CONFIG_HOME/uzbl/scripts/formfiller.sh new
# bind Ie = sh $XDG_CONFIG_HOME/uzbl/scripts/formfiller.sh edit

# user arg 1:
# load: load from file into form. creates new if doesn't exist yet
# new:  creates a new file and lets you edit
# edit: edit the file, loading it if it doesn't exist (TODO: is it correct to load first, and edit after?)

# something else (or empty): if file not available: new, otherwise load.


# arguments
config=$1;  shift
pid=$1;     shift
xid=$1;     shift
fifo=$1;    shift
socket=$1;  shift
url=$1;     shift
title=$1;   shift
cmd=$1;     shift

# settings
keydir=${XDG_DATA_HOME:-$HOME/.local/share}/uzbl/forms
js_helper=${XDG_CONFIG_HOME:-$HOME/.config}/uzbl/scripts/formmanager.js

# set your editor here.  Note this is not the same as $EDITOR as we cannot just run an editor in the foreground in a terminal.
editor=gvim
#editor='urxvt -e vim'
domain=$(echo $url | sed -re 's|(http\|https)+://([A-Za-z0-9\.]+)/.*|\2|')

[[ -d "$keydir" ]] || mkdir -p "$keydir"
[[ -d "`dirname $keydir`" ]] || exit 1
[[ -e $js_helper ]] || exit 1

function new(){
    uzblctrl -s "$socket" -c 'print @<dumpForms()>@' | sed -e 's|},{|}\n{|g' -e 's|\(fields: \[\)|\1\n  |g' -e 's|}, {|}\n, {|g' -e 's|}]}|}\n]}\n|g' > "$keydir/$domain"
}
function edit(){
    $editor $keydir/$domain
}
function load(){
    grep -v "^#" $keydir/$domain | tr -d '\t\n'
    echo 'js setForms('$(grep -v "^#" $keydir/$domain | tr -d '\t\n')')' > "$fifo";
}

# make sure to load up the
echo script $js_helper > "$fifo";

case $cmd in
    "load")
        [[ -e $keydir/$domain ]] || new
        load
        ;;
    "new")
        new
        edit
        ;;
    "edit")
        [[ -e $keydir/$domain ]] || load
        edit
        ;;
     *)
        echo 'js alert("No action specified: new, load or edit")' > "$fifo"
        ;;
esac

# vim:set et ts=4 sw=4:
