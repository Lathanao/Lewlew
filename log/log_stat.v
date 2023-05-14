module log

import sqlite
import os
import json
import time
import strings

struct File {
mut:
	real_path string
	tmp_path  string
	word      string
	fields    []string
	name      string
	nb_line   int
}

struct LogBatch {
mut:
	name  string
	files []File
}

fn sort_log_batches_by_middleware() map[string]map[string]File {
	start1 := time.ticks()
	mut raw_list := os.ls('/home/tanguy/logs') or {['']}
	mut logs_list := []string{}

	for k, file_name in raw_list {
		if file_name.contains('.log') {
			logs_list << file_name
		}
	}
	logs_list.sort()
	mut score := [][]int{len: logs_list.len, init: []int{len: logs_list.len, init: 0}}

	mut res := map[string]map[string]File{}

	for k, file_a in logs_list {
		cc := logs_list[k + 1..logs_list.len]

		for j, file_b in cc {
			// cal := strings.levenshtein_distance(file_a, file_b)
			mut cal := 0
			short_a := file_a.split('.log').first()
			short_b := file_b.split('.log').first()

			if short_a == short_b {
				res[short_a][file_a] = File{}
				res[short_b][file_b] = File{}
				// res[short_b] << file_b
				cal = 1
			}

			score[k][k + j + 1] = cal
			score[k + j + 1][k] = cal

			// println(k.str() + ' ' + file_a.split('.log').first())
			// println(j.str() + ' ' + file_b.split('.log').first())
			// println(file_a + ' vs ' + file_b + ' : ' + cal.str())
			// println('========= END ==========')
		}
	}
	// println('========== type res =========')
	// println(typeof(res))
	
	for k, v in res {
		// println('========== For =========')
		// println(v)
		
	}
	finish1 := time.ticks()
	// println('process_thesaurus_light      time ${finish1 - start1} ms')

	return res 
}

// pub fn calculate_score(a Song, b Song) int {

// 	mut similar := map[string]int

// 	for word in a.fields {
// 		if b.fields.index(word) != -1 {
// 			similar[word] = similar[word] + 1
// 		}
// 	}

// 	mut score := 0
// 	for k, v in similar {
// 		score = score + v
// 	}

// 	return score
// }

// strings.levenshtein_distance('flomax', 'volmax') == 3

// fn  main() {

// 	start1 := time.ticks()
// 	process_song() ?
// 	finish1 := time.ticks()

// 	println('process_thesaurus_light      time ${finish1 - start1} ms')
// }

// fn  process_song() ? {
// 	mut songs := [Song{path:'/var/www/vproject/test/thesaurus/songs/Adele_Lyrics.txt'},
// 								Song{path:'/var/www/vproject/test/thesaurus/songs/Eagles_Lyrics.txt'},
// 								Song{path:'/var/www/vproject/test/thesaurus/songs/The_Cure_Lyrics.txt'},
// 								Song{path:'/var/www/vproject/test/thesaurus/songs/U2_Lyrics.txt'}]

// 	for mut song in songs {
// 			tmp := os.read_file(song.path)?
// 			song.fields << tmp.fields()
// 			song.name = song.path.split_any('/').last()#[..-11]
// 	}

// 	mut score := [][]int{len: songs.len, init: []int{len: songs.len, init: 0}}
// 	println(score)

// 	for k, songa in songs {	
// 		cc := songs[k + 1..songs.len]

// 		for j, songb in cc {

// 			cal := calculate_score(songa, songb)
// 			score[k][k+j+1] = cal
// 			score[k+j+1][k] = cal
// 			println(songa.name + ' vs ' + songb.name + ' : ' + cal.str())
// 		}
// 	}
// }

// pub fn calculate_score(a Song, b Song) int {

// 	mut similar := map[string]int

// 	for word in a.fields {
// 		if b.fields.index(word) != -1 {
// 			similar[word] = similar[word] + 1
// 		}
// 	}

// 	mut score := 0
// 	for k, v in similar {
// 		score = score + v
// 	}

// 	return score
// }
