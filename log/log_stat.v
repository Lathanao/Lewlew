// Copyright 2022, Tanguy Salmon. All rights reserved.
// MIT license, please check LICENSE file.

module log

struct StatProgressPligin {
	host_name map[string]map[string]int
	state 		map[string]map[string]int
	@in 			map[string]map[string]int
	out 			map[string]map[string]int
	mac 			map[string]map[string]int
	src 			map[string]map[string]int
	dst 			map[string]map[string]int
	tos 			map[string]map[string]int
	prec 			map[string]map[string]int
}

pub fn api_ufw_log_stat() map[string][]map[string]map[string]int {
	raw_list := read_and_list_raw_log_files()

	logs_batches := sort_files_by_middleware(raw_list)

	raw_ufw_low := concatain_log_by_batch(logs_batches['ufw'])

	parsed_rows := parse_concatained_raw_file(raw_ufw_low)

	stat_rows := extract_stats(parsed_rows)

	return stat_rows
}

pub fn extract_stats(rows []Ufwrow) map[string][]map[string]map[string]int {

	mut result := map[string]map[string]int{}

	for line in rows {
		$for field in Ufwrow.fields {
			$if field.typ is string {
				fieldd := field.name.str()
				valuee := line.$(field.name).str()
				if result[fieldd][valuee] == 0 {
					result[fieldd][valuee] = 0
				}
				result[fieldd][valuee]++
			}
		}
	}

	mut stat := map[string][]map[string]map[string]int{}

	stat['fullstat'] << result.clone()
	return stat
}

pub fn api_log_menu_ttt() map[string][]map[string]string {
	mut menu := map[string][]map[string]string{}

	raw_list := read_and_list_raw_log_files()

	all_batch := sort_files_by_middleware(raw_list)

	for name_batch, _ in all_batch {
		mut name_batch_url := map[string]string{}
		name_batch_url['url'] = '/log/' + name_batch.replace('.', '-')
		name_batch_url['label'] = name_batch.capitalize()
		menu['menu'] << name_batch_url
	}

	return menu
}
