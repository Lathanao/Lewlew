module classes

//import crypto.sha256
//import rand
//import os
//import time
import sqlite

[heap]
struct AdminAbstract {
mut:
    pragma      []string [skip]
    schema      []string [skip]
    schema_lang []string [skip]
    db  		sqlite.DB [skip]
    cache		map[string]string [skip]
}

fn (mut a Admin) init() {
	//println('---AdminUser-----init-------')
	// res,_ := a.db.query( 'pragma table_info("admin_user");' )
	//println(res)
	// for line in res {
	// 	a.schema << line.vals[1]
	// }
}

fn (a Admin) hydrate (data sqlite.Row) Admin {
	//println('---AdminUser---hydrate------')
    mut result := a
	for iii, name_field  in a.schema {
		$for field in Admin.fields {
			$if field.typ is int {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].int()
				}	
			}
			$if field.typ is string {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii]
				}
			}
			$if field.typ is bool {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].bool()
				}
			}
			$if field.typ is f32 {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].f32()
				}
			}
		}
	}
    return result
}