module classes

// import crypto.sha256
// import rand
// import os
// import time
import mysql

struct AdminFilter {
mut:
	filter Filter
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

pub fn (a AdminFilter) filter_by_email(criteria map[string]string) Admin {
	// filter := make_query_condition(criteria, 'employee')
	// query := 'SELECT * FROM `admin_user` $filter;'
	// db := sqlite.connect('/var/www/vproject/blog/db/blog.db') or { panic(err) }
	// _, code :=  db.query( query )

	// if code != 101 { panic('No connexion to database') }
	// if res.len == 0 {
	// 	return [a]
	// }

	mut result := Admin{}
	// for re in res {
	// 	result << a.hydrate(re)
	// }

	return result
}
