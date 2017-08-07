ilo_list() {
	if [ -z $@ ]; then
		echo "ilo_list <subnet>"
		echo "example: ilo_list 192.168.1.0/24"
	else
		sudo nmap -n -P0 -sS -p 17988 -oG - $@ | fgrep /open/ | awk '{print $2}'
	fi
}
