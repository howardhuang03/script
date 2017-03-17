#!/bin/sh

. $IPKG_INSTROOT/lib/functions.sh

realm="$(uci_get system.@system[0].hostname)"
target=hq.tar.gz

function luci_key_change {
	echo "Chagne LuCI password"
	passwd
}

function webif_key_change {
	echo "Change webif password"
	sed -i 's/xxxx/xxxx/g' /etc/httpd.conf
}

function change_4free_config {
        echo "Change fourfree host and redirect url"
	uci set fourfree.settings.redirect_host=xxx.com.tw
	uci set fourfree.settings.redirect_url=http://xxx.com.tw/site/GW-HQ/
        uci commit fourfree
}

function change_wifi_config {
	echo "Change wifi SSID & password"
	uci set wireless.4free_5G.ssid=LEDE-99G
        uci set wireless.4free_5G.encryption=psk2
        uci set wireless.4free_5G.key=12345678
	uci set wireless.4free.ssid=LEDE
        uci set wireless.4free.encryption=psk2
        uci set wireless.4free.key=12345678
        uci commit wireless
}

# Enable 4free function
if [ "$realm" != "hq" ]; then
	scp howardhuang@192.168.0.66:share/tmp/hq/hq.tar.gz /
	if [ -f "$target" ]; then
		tar -zxvf $target
	fi

	luci_key_change
	webif_key_change
	change_wifi_config
	change_4free_config
	echo "Update machine to 4free hq, please reboot the device"
	exit 0
fi

# Marker checking rule
echo "Marker checking rule"
nslookup wifitest.office.pilottv.com.tw

# ndskeeper checking rule
echo -e "Run ndskeeper"
/etc/nodogsplash/ndskeeper.sh
echo -e "nodogsplash status: "
cat /tmp/state/nodogsplash

# Print iptables mangle's table
echo -e "\n\nPrint out mangle table"
iptables -t mangle -L
