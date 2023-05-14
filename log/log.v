module log

import time
import os



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

pub fn api_log_menu() map[string][]map[string]string  {

	mut menu := map[string][]map[string]string 

	all_batch := sort_log_batches_by_middleware()
	
	for name_batch, _ in all_batch {

		mut name_batch_url := map[string]string{}
		name_batch_url['url'] = '/log/' + name_batch.replace('.', '-')
		name_batch_url['label'] = name_batch.capitalize()

		menu['menu'] << name_batch_url
	}

	return menu
}
