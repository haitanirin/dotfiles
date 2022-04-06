#!/bin/sh

function scroll () {
	prefix="$1"
	scrolling="$2"
	suffix="$3"
	if [ "$(echo -n $scrolling |wc -c)" -gt 20 ]; then
		temp="$(echo "$scrolling"| sed "s/^\(.\{20\}\)\(.*\)$/\1[\2]/"| sed "s/\[ *\]$//"| sed "s/\[.*\]$//")"
		echo "$prefix%{T1}$temp%{T-}$suffix"
		sleep 1
		zscroll -l 20 \
        		--delay 0.2 \
			--before-text "$prefix%{T1}" \
			--after-text "%{T-}$suffix" \
			--scroll-padding "     " \
			--update-check true "echo $(get_scroll)" &

		wait
	else
		echo "$prefix%{T1} $scrolling %{T-}$suffix"
	fi
} #

function get_artist () {
	echo "$(playerctl -p spotify metadata --format "{{ artist }}"| sed -e "s/[[(]....*[])]*//g" | sed "s/ *$//"| sed "s/^\(.\{20\}[^ ]*\)\(.*\)$/\1[\2]/"| sed "s/\[ *\]$//"| sed "s/\[.*\]$/.../")"
} #

function get_scroll () {
	tmp="$(get_title)"
	echo "$(echo "$tmp" | sed 's/'\''/\\'\''/g' | sed 's/'\"'/\\'\"'/g')"
} #

function get_title () {
	echo "$(playerctl -p spotify metadata --format "{{title}}"|sed 's/'\'\''/'\"'/g' )"
} #

[ ! -z "$(playerctl -p spotify status 2>/dev/null)" ] \
	&& artist=$(get_artist) \
	&& title=$(get_title) \
    && ([ -z "$artist$title" ] && echo "Spotify is not connected on this pc" && exit 0 || scroll "%{F#DDB6F2}$artist%{F#D9E0EE} [" "$title" "]%{F-}" ) \
	|| exit 1
