module classe
import sqlite
/* import sqlite */

[heap]
pub struct Factory {
	db    	sqlite.DB
	
mut:
	filter  Filter
	admin   AdminFilter
	id    	int
	title 	string
	text  	string
	
	cache_pragma_def map[string][]string
}

pub fn (mut f Factory) start() &Factory {


	return f
}

pub fn (f Factory) product() Product {
	mut p := (Product{db: &f.db})

	// // Add Generic field to easy iterate in hydrate(), etc...
	// mut res,_ := p.db.exec( 'pragma table_info("product");' )
	// for line in res {
	// 	p.schema << line.vals[1]
	// }
	// // Add Generic Lang field to easy iterate in hydrate(), etc...
	// res,_ = p.db.exec( 'pragma table_info("product_lang");' )
	// for line in res {
	// 	if line.vals[1] == 'id' { continue } // if not remove, will trouble hydrate() 
	// 	p.schema_lang << line.vals[1]
	// }
	// // Add schema name to know the table base quikly
	// p.schema_name = 'product'
	return p
}

pub fn (mut f Factory) admin() AdminFilter {
	println('-------- Factory Admin --------')
	// a := (Admin{AdminAbstract{db: &f.db}, AdminFilter{}, AdminEntity{}})
	f.admin = (AdminFilter{})

	return f.admin
}