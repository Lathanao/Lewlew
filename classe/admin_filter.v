// Copyright (c) 2019-2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by a GPL license that can be found in the LICENSE file.
module classes

//import crypto.sha256
//import rand
//import os
//import time
import sqlite

struct AdminFilter {



}

// struct SshKey {
// 	id         int
// 	user       int
// 	title      string
// 	sshkey     string
// 	is_deleted bool
// }

// struct Email {
// 	id    int
// 	user  int
// 	email string
// }

// struct Contributor {
// 	id   int
// 	user int
// 	repo int
// }

// struct OAuth_Request {
// 	client_id     string
// 	client_secret string
// 	code          string
// }


pub fn (a AdminFilter) filter_by_email (criteria map[string]string) Admin {
	// println('--- Admin ---filter_by_query------')
	// filter := make_query_condition(criteria, 'employee')

	// query := 'SELECT * FROM `admin_user` $filter;'
	
	// //println(query)
	// //println(a.db)

	// println('--- Admin ---exec------')
	// db := sqlite.connect('/var/www/vproject/blog/db/blog.db') or { panic(err) }
	// _, code :=  db.exec( query )

	// if code == 101 {
	// 	println('coonn db')
	// } else {
	// 	{ panic('No connexion to database') }
	// }

	// if res.len == 0 {
	// 	println(3)
	// 	return [a]
	// }

	mut result := Admin{}
	// println('-----------AdminUser-------filter_by_query')
	// for re in res {
	// 	println('---AdminUser---hydrate------')
	// 	result << a.hydrate(re)
	// }

	return result
}