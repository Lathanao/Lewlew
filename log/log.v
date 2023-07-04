// Copyright 2022, Tanguy Salmon. All rights reserved.
// MIT license, please check LICENSE file.

module log

import time

const (
	log_path = '/home/tanguy/logs'
	log_ext  = '.log'
)

struct File {
mut:
	real_path string
	tmp_path  string
	word      string
	fields    []string
	name      string
	wc_l      int
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

	return time.Time{}
}

pub fn api_log_menu() map[string][]map[string]string {
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
