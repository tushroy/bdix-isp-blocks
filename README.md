bdix-asn-prefix
==

This is a crude list of BDIX ASN and IP Prefixes.

The `bdix-asn-list.txt` is curated from [Hurricane Electric](https://bgp.he.net/exchange/BDIX) BDIX overview page.

Running `asn2prefix.sh` will download IP Prefixes of those ASN from [dan.me.uk/bgplookup](https://www.dan.me.uk/bgplookup) and do some grepping to output to 2 text files `bdix-prefix_ipv4.txt` and `bdix-prefix_ipv6.txt`.

You can then run `xargs` on prefix.txt for creating filewall (iptables/routeros/cisco etc...) rules or just do whatever you want.


Ex:

```sh
xargs -I {} echo iptables -A bdix-filter -s {} < bdix-prefix_ipv4.txt
```

```sh
#/ip firewall address-list
xargs -I {} echo add address={} list=bdix < bdix-prefix_ipv4.txt
```

