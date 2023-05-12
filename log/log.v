module log

import time
import os

pub struct Ufwrow {
pub mut:
	date      time.Time
	host_name string = '1'
	state     string = '1'
	out       string = '1'
	mac       string = '1'
	src       string = '1'
	dst       string = '1'
	// len       int
	// tos       string
	// prec      string
	// ttl       int
	// id        int
	// proto     int
}

pub fn api_log_count() map[string]int {
	mut count := map[string]int{}
	// count['count'] = os.execute_or_panic('cat ' + '/home/tanguy/logs/ufw.light.log | wc -l')
	count['count'] = 42
	return count
}

pub fn api_log_column() map[string]string {
	mut ufw_log := map[string]string{}
	ufw_log['date'] = 'Date'
	ufw_log['host_name'] = 'Host Name'
	ufw_log['state'] = 'State'
	ufw_log['in'] = 'In'
	ufw_log['out'] = 'Out'
	ufw_log['mac'] = 'Mac'
	ufw_log['src'] = 'Src'
	ufw_log['dst'] = 'Dst'
	ufw_log['len'] = 'Len'
	ufw_log['tos'] = 'Tos'
	ufw_log['prec'] = 'Prec'
	ufw_log['ttl'] = 'Ttl'
	ufw_log['id'] = 'Id'
	ufw_log['proto'] = 'Proto'

	return ufw_log
}

pub fn api_log_ufw() []Ufwrow {
	return api_log()
}

pub fn api_log() []Ufwrow {
	raw_list := os.execute_or_panic('cat ' + '/home/tanguy/logs/ufw.light.log')
	mut list := []Ufwrow{}

	for line in raw_list.output.split_into_lines() {
		splitted := line.split(' ')
		param := line.split('] ')

		mut result := Ufwrow{
			date: parse_date(line)
			host_name: splitted[4]
			// state: splitted[7] + ' ' + splitted[8]
		}

		// for attr in line.split(' ') {
		// 	if !attr.contains('=') {
		// 		continue
		// 	}

		// 	val := attr.split('=')
		// 	vall := val[0].to_lower()
		// 	$for field in Ufwrow.fields {
		// 		$if field.typ is string {
		// 			if field.name == vall {
		// 				result.$(field.name) = val[1]
		// 				continue
		// 			}
		// 		}
		// 		$if field.typ is int {
		// 			if field.name == vall {
		// 				result.$(field.name) = val[1].int()
		// 				continue
		// 			}
		// 		}
		// 	}
		// }
		list << result
	}

	return list
}

pub fn parse_date(line string) time.Time {
	month := line[0..3]
	day := line[4..6]
	oclock := line[7..15]

	month_names := ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov',
		'Dec']
	mut month_nb := 0
	for i, name in month_names {
		if month == name {
			month_nb = i + 1
			break
		}
	}

	date := time.Time{
		year: time.utc().year
		month: month_nb
		day: day.trim(' ').int()
		hour: oclock[..2].int()
		minute: oclock[3..5].int()
		second: oclock[6..8].int()
	}

	return date
}
