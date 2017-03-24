#!/bin/sh

. $IPKG_INSTROOT/lib/functions.sh

PROGNAME=$(basename $0)
realm="$(uci_get system.@system[0].hostname)"
hwmach="howardhuang@192.168.0.66"
target=hq.tar.gz
maindomain=xxxx.com.tw
mainhost=www.$maindomain
replacedomain=$maindomain
testdomain=yyyy.com.tw
testhost1=wifitest.office.$testdomain
testhost2=wifitestpc.office.$testdomain
realhost=$testhost2
ssid=wifi-test
sysupgradefw="lede-ar71xx-generic-archer-c7-v2-squashfs-sysupgrade.bin"
target_msg="4FRee Request Info Page"

# Show help
show_help() {
	cat <<- EOF
	$PROGNAME [-f] [-s] [-u]
	Usage:
	  -f: Enable capital portal function
	  -s: Show capital portal related status
	  -u: Execute firmware upgrade
	EOF
}

luci_key_change() {
	echo "Chagne LuCI password to '123' haha"
	passwd
}

webif_key_change() {
	echo "Change webif password to '123' haha"
	sed -i 's/xxxxx/xxxxx/g' /etc/httpd.conf
}

squid_domain_change() {
	old_domain=$1
	echo "old_domain: $old_domain"
	new_domain=$2
	echo "new_domain: $new_domain"
	echo "Add test domain"
	sed -i "s/$old_domain/$new_domain/g" /etc/squid/squid.conf.in
}

change_4free_config() {
	echo "Change fourfree host and redirect url"
	uci set fourfree.settings.redirect_host=$realhost
	uci set fourfree.settings.redirect_url=http://$realhost/site/GW-HQ/
	uci commit fourfree
}

change_wifi_config() {
	echo "Change wifi SSID & password"
	uci set wireless.4free_5G.ssid=$ssid-5G
	uci set wireless.4free_5G.encryption=psk2
	uci set wireless.4free_5G.key=12345678
	uci set wireless.4free.ssid=$ssid
	uci set wireless.4free.encryption=psk2
	uci set wireless.4free.key=12345678
	uci commit wireless
}

enable_portal() {
	# Enable capital portal
	echo "Activating capital portal"
	cd /
	scp $hwmach:share/tmp/hq/$target /
	if [ -f "$target" ]; then
		tar -zxvf $target
		rm $target
	fi

	luci_key_change
	webif_key_change
	squid_domain_change $replacedomain $testdomain
	change_wifi_config
	change_4free_config
	echo "Finish update to 4free hq, reboot the device"
	exit 0
}

check_status() {
	# Marker checking rule
	echo "Marker checking rule"
	nslookup $realhost

	# ndskeeper checking rule
	echo -e "\n\nndskeeper checking rule"
	hsinfo="http://$realhost/hsinfo"
	wget -t 1 -T 15 -q -O- $hsinfo | grep '4FRee Request Info Page'
	#echo -e "Run ndskeeper"
	#/etc/nodogsplash/ndskeeper.sh
	echo -e "\nnodogsplash status: "
	cat /tmp/state/nodogsplash

	# offline-notifier checking
	echo -e "\noffline-notifier status: "
	cat /tmp/state/offline-notifier

	# Print iptables mangle's table
	echo -e "\n\niptalbes MANGLE rule"
	iptables -t mangle -L
}

do_sysupgrade() {
	local target=$sysupgradefw

	if [ -f "/tmp/$target" ]; then
		echo "Download sysupgrade firmware"
		scp $hwmach:share/$target /tmp
	fi

	echo "Performing sysupgrade with $target"
	sysupgrade -v $target
}

main() {
	while getopts :fsu flag
	do
		case $flag in
		f)
			enable_portal
			;;
		s)
			check_status
			;;
		u)
			do_sysupgrade
			;;
		\?)
			show_help
			exit 0
			;;
		esac
	done
}

# Start main process
[ -z "$1" ] && main -h
main "$@"
