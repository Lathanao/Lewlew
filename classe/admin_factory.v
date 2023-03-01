module classes

//import crypto.sha256
//import rand
//import os
//import time
import mysql

pub struct AdminFactory {
	db    			&mysql.Connection
mut: 
	filter			Filter
	pragma      []string
	schema      []string
	schema_lang []string
	schema_name string
	cache				map[string]string [skip]
}

pub fn (a AdminFactory) create_admin(criteria map[string]string) ?Admin {
	// dump(a)
	schema_name := 'ps_employee'

	query_main := 'DESCRIBE `$schema_name`;'
	query_lang := 'DESCRIBE `$schema_name`;'
	

	mut connection := mysql.Connection{
			username: 'magento'
			password: 'magento'
			dbname: 'raw_pcw'
	}

	// mut p := (Product{db: &f.db})
	// // Add Generic field to easy iterate in hydrate(), etc...


	// mut res := connection.real_query(query_main)?
	
	// // Add Generic Lang field to easy iterate in hydrate(), etc...
	// res,_ = p.db.exec( 'pragma table_info("product_lang");' )
	// for line in res {
	// 	if line.vals[1] == 'id' { continue } // if not remove, will trouble hydrate() 
	// 	p.schema_lang << line.vals[1]
	// }

	return Admin{}
}

pub fn (a AdminFactory) fetch_admin(criteria map[string]string) ?Admin {

	// filter := make_query_condition(criteria, 'ps_employee')

	// query := 'SELECT * FROM `ps_employee` $filter;'
	
	// println(a)
	// println(query)
	// println(filter)

	// mut connection := mysql.Connection{
	// 		username: 'magento'
	// 		password: 'magento'
	// 		dbname: 'raw_pcw'
	// }
	// connection.connect() ?
	// results := connection.query(query) ?

	// println(results)
	// println(results.maps())
	// println(typeof(results.maps()))

	// // println(a.hydrate(results.maps()))

	// println('return result')
	return Admin{}
}


pub fn (a AdminFactory) fetch_admin_by_email(criteria map[string]string) ?Admin {

	// filter := make_query_condition(criteria, 'ps_employee')

	// query := 'SELECT * FROM `ps_employee` $filter;'
	
	// println(a)
	// println(query)
	// println(filter)

	// mut connection := mysql.Connection{
	// 		username: 'magento'
	// 		password: 'magento'
	// 		dbname: 'raw_pcw'
	// }
	// connection.connect() ?
	// results := connection.query(query) ?

	// println(results)
	// println(results.maps())
	// println(typeof(results.maps()))

	// // println(a.hydrate(results.maps()))

	// println('return result')
	return Admin{}
}

// fn (a AdminFactory) hydrate (data []map[string]string) []Admin {

// 	// println('--------------HYDRATE')
// 	// println('---data')
// 	// println(data.len)
// 	// println(data)
// 	// println(p.pragma.len)
// 	// println(p.pragma)
// 	mut schema := p.schema.clone()
// 	schema << p.schema_lang
//     mut result := p
// 	for iii, name_field in schema {
// 		//println(iii)
// 		//println(data.vals[iii])
// 		$for field in Product.fields {
// 			$if field.typ is int {
// 				if field.name == name_field {
// 					result.$(field.name) = data.vals[iii].int()
// 					//println('set ' + field.name + ': ' + data.vals[iii])
// 					continue
// 				}	
// 			}
// 			$if field.typ is string {
// 				if field.name == name_field {
// 					result.$(field.name) = data.vals[iii]
// 					//println('set ' + field.name + ': ' + data.vals[iii])
// 					continue
// 				}
// 			}
// 			$if field.typ is bool {
// 				if field.name == name_field {
// 					result.$(field.name) = data.vals[iii].bool()
// 					//println('set ' + field.name + ': ' + data.vals[iii])
// 					continue
// 				}
// 			}
// 			$if field.typ is f32 {
// 				if field.name == name_field {
// 					result.$(field.name) = data.vals[iii].f32()
// 					//println('set ' + field.name + ': ' + data.vals[iii])
// 					continue
// 				}
// 			}
// 		}
// 	}
// 	//println(result)
//     return result
// }