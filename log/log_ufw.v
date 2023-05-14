module log

import os
import time
import strings

pub struct Ufwrow {
pub mut:
	date      time.Time
	host_name string
	state     string
	@in       string
	out       string
	mac       string
	src       string
	dst       string
	len       int
	tos       string
	prec      string
	ttl       int
	id        int
	proto     int
}


pub fn api_ufw_log_count() map[string]int {
	mut count := map[string]int{}
	res := os.execute_or_panic('cat /home/tanguy/logs/ufw.light.log | wc -l')
	count['count'] = res.output.int()
	return count
}

pub fn api_ufw_log_column() map[string]string {
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

pub fn api_ufw_log() []Ufwrow {

	raw_list := read_and_list_raw_log_files()

	logs_batches := sort_files_by_middleware(raw_list)

	raw_ufw_low := concatain_log_by_batch(logs_batches['ufw'])

	parsed_rows := parse_concatained_raw_file(raw_ufw_low)

	// stat_rows := extract_stats(parsed_rows)

	return parsed_rows
}

fn read_and_list_raw_log_files() []string {
	raw_list := os.ls(log_path) or { [''] }
	return raw_list
}

fn sort_files_by_middleware(raw_list []string) map[string]map[string]File {
	mut logs_list := []string{}

	for k, file_name in raw_list {
		if file_name.contains(log_ext) {
			logs_list << file_name
		}
	}
	logs_list.sort()

	mut res := map[string]map[string]File{}
	for k, file_a in logs_list {
		cc := logs_list[k + 1..logs_list.len]

		for j, file_b in cc {
			mut cal := 0
			short_a := file_a.split('.log').first()
			short_b := file_b.split('.log').first()

			if short_a == short_b {
				res[short_a][file_a] = File{
					real_path: log_path + os.path_separator + file_a
				}
				res[short_b][file_b] = File{
					real_path: log_path + os.path_separator + file_b
				}

				cal = 1
			}
		}
	}

	return res
}

fn concatain_log_by_batch(logs_batch map[string]File) string {
	mut full_result := ''
	for label, file in logs_batch {
		if file.real_path.ends_with('.gz') {
			full_result += os.execute_or_panic('zcat ' + file.real_path).output
		} else {
			full_result += os.read_file(file.real_path) or { '' }
		}
	}

	return full_result
}

pub fn parse_concatained_raw_file(raw_ufw_low string) []Ufwrow {
	mut list := []Ufwrow{}

	for line in raw_ufw_low.split_into_lines() {
		splitted := line.split(' ')
		param := line.split('] ')

		mut result := Ufwrow{
			date: parse_date(line)
			host_name: splitted[4]
			state: splitted[7] + ' ' + splitted[8]
		}

		for attr in line.split(' ') {
			if !attr.contains('=') {
				continue
			}

			val := attr.split('=')
			vall := val[0].to_lower()
			$for field in Ufwrow.fields {
				$if field.typ is string {
					if field.name == vall {
						result.$(field.name) = val[1]
						continue
					}
				}
				$if field.typ is int {
					if field.name == vall {
						result.$(field.name) = val[1].int()
						continue
					}
				}
			}
		}
		list << result
	}

	return list.filter(it.src.contains('192.168.1.34'))
}
