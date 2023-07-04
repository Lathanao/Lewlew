module classes

import mysql

pub struct AdminFactory {
mut:
	db          mysql.Connection
	filter      Filter
	pragma      []string
	schema      []string
	schema_lang []string
	schema_name string
	cache       map[string]string [skip]
}

pub fn (a AdminFactory) init() {
	// dump(a)
	// schema_name := 'ps_employee'

	// query_main := 'DESCRIBE `$schema_name`;'

	// mut p := (Product{db: &f.db})
	// // Add Generic field to easy iterate in hydrate(), etc...

	// mut res := connection.real_query(query_main)?

	// // Add Generic Lang field to easy iterate in hydrate(), etc...
	// res,_ = p.db.exec( 'pragma table_info("product_lang");' )
	// for line in res {
	// 	if line.vals[1] == 'id' { continue } // if not remove, will trouble hydrate()
	// 	p.schema_lang << line.vals[1]
	// }
}

pub fn (mut a AdminFactory) fetch_admin(criteria map[string]string) ?Admin {
	filter := make_query_condition(criteria, 'ps_employee')
	query := 'SELECT * FROM `ps_employee` $filter;'

	a.db.connect()?
	results := a.db.query(query)?
	a.db.close()

	result_maps := results.maps().clone()

	// unsafe {
	// 	results.free()
	// 	result_maps.free()
	// }
	// a.db.close()

	if result_maps.len > 0 {
		return a.hydrate(result_maps[0])
	} else {
		return Admin{}
	}
}

fn (a AdminFactory) hydrate(data map[string]string) Admin {
	mut result := AdminEntity{}
	$for field in AdminEntity.fields {
		$if field.typ is int {
			result.$(field.name) = data[field.name].int()
		}
		$if field.typ is string {
			result.$(field.name) = data[field.name]
		}
		$if field.typ is bool {
			result.$(field.name) = data[field.name].bool()
		}
		$if field.typ is f32 {
			result.$(field.name) = data[field.name].f32()
		}
	}
	return Admin{AdminAbstract{}, result}
}
