module classe
import mysql
/* import sqlite */

[heap]
pub struct Factory {
	db    	&mysql.Connection
	
mut:
	filter  Filter
	adminfactory   AdminFactory
	id    	int
	title 	string
	text  	string
	
	cache_pragma_def map[string][]string
}

pub fn (mut f Factory) start() &Factory {
	dump('------')
	dump(f.db)
	dump('------')
	f.filter = Filter{db: f.db}
	// f.adminfactory = AdminFactory{db: f.db}
	dump(f)
	return f
}

pub fn (f Factory) product() Product {
	mut p := (Product{db: &f.db})

	// // Add Generic field to easy iterate in hydrate(), etc...
	// mut res,_ := p.db.query( 'pragma table_info("product");' )
	// for line in res {
	// 	p.schema << line.vals[1]
	// }
	// // Add Generic Lang field to easy iterate in hydrate(), etc...
	// res,_ = p.db.query( 'pragma table_info("product_lang");' )
	// for line in res {
	// 	if line.vals[1] == 'id' { continue } // if not remove, will trouble hydrate() 
	// 	p.schema_lang << line.vals[1]
	// }
	// // Add schema name to know the table base quikly
	// p.schema_name = 'product'
	return p
}

pub fn (mut f Factory) admin() AdminFactory {
	return f.adminfactory
}



pub fn (mut f Factory) admin_filter_by_email(criteria map[string]string) ?Admin {
	return f.adminfactory.fetch({'email': criteria['email']})
}