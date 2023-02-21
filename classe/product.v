module classes
import sqlite
import time
import strings
// import v.ast
// import strings
// import v.table
// import v.util


pub struct Product {
pub mut:
	id                  int
	sku                 string
	ean13               string

	collections         string
	ptype                string
	images              []Image
	featured_image      string
	featured_media      string

	handle              string
	variants            string
	selected_variant    string
	selected_or_first_available_variant string
	first_available_variant 	string
	has_only_default_variant 	string

	options 					string
	options_with_values 		string
	price                       int
	price_max                   int
	price_min                   int
	price_varies                int
	compare_at_price_max        int
	compare_at_price_min        int
	compare_at_price_varies     int
	brand						int 
	vendor                      int
	template_suffix             string

	id_lang           int
	title             string
	description       string
	content           string
	link_rewrite      string
	meta_description  string
	meta_keywords     string
	meta_title        string
	url               string
	tags              []int
	available		  int
	published_at      i64
	created_at        i64
	modified_at       i64  

mut:
	filter		Filter
	pragma      []string
	schema      []string
	schema_lang []string
	schema_name string
	db  		sqlite.DB [skip]
	cache		map[string]string [skip]
}


pub const (
    VISIBILITY_NOT_VISIBLE = 1
    VISIBILITY_IN_CATALOG = 2
    VISIBILITY_IN_SEARCH = 3
    VISIBILITY_BOTH = 4
)


	
pub fn (mut p Product) save() Product {
	
	today :=  time.now()

	println("------save-----")
	println(p)
	mut condition_where := ';'
	mut condition_where_lang := ';'
	mut type_query := 'INSERT INTO '

	
	fields, values, update := dehydrate_product(p)
	fieldsl, valuesl, updatel := dehydrate_product_lang(p)
	if p.id == 0 {
		next_id := p.db.q_int('SELECT MAX(id) from product') + 1
		p.id = next_id

		// query := "INSERT INTO `product` ($fields)  VALUES ($values)"
		// sig, code := p.db.exec(query)
		// // println(query)
		// // println(sig)
		// // println(code)

		// queryl := "INSERT INTO `product_lang` ($fieldsl)  VALUES ($valuesl)"
		// sigl, codel := p.db.exec(queryl)
		// println(queryl)
		// println(sigl)
		// println(codel)

	} else {
		condition_where = 'id = $p.id; '
		condition_where_lang = 'id_product = $p.id; '

		// mut data := unify_data_for_update(fields, values)

		println("--------- UPDATE --------")
		println(update)
		println("--------- UPDATE l --------")
		println(updatel)

		query := 'UPDATE `product` SET $update WHERE $condition_where;'
		sig, code := p.db.exec(query)
		println(query)
		println(sig)
		println(code)

		queryl := 'UPDATE `product_lang` SET $updatel WHERE $condition_where_lang;'
		sigl, codel := p.db.exec(queryl)
		println(queryl)
		println(sigl)
		println(codel)
	}
	
	return p
}

pub fn (mut p Product) delete() Product {

	return p
}


pub fn unify_data_for_update(fields string, values string) string {
	mut values_to_update := strings.new_builder(1024)

	println("-------- unify_data_for_update --------")
	for iii, name_field  in fields {
		println("-------- $iii $name_field ")
		values_to_update.write_string('\r\n$name_field = $values[iii],')
	}
	return values_to_update.str()
}

// Need to get the full set, like `select * from ...`
// Create a full featured structure after received data from database
// This method should be called just below a db.exec(SELECT ... WHERE id = X)
fn (mut p Product) hydrate (data sqlite.Row) Product {

	// println('--------------HYDRATE')
	// println('---data')
	// println(data.len)
	// println(data)
	// println(p.pragma.len)
	// println(p.pragma)
	mut schema := p.schema.clone()
	schema << p.schema_lang
    mut result := p
	for iii, name_field in schema {
		//println(iii)
		//println(data.vals[iii])
		$for field in Product.fields {
			$if field.typ is int {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].int()
					//println('set ' + field.name + ': ' + data.vals[iii])
					continue
				}	
			}
			$if field.typ is string {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii]
					//println('set ' + field.name + ': ' + data.vals[iii])
					continue
				}
			}
			$if field.typ is bool {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].bool()
					//println('set ' + field.name + ': ' + data.vals[iii])
					continue
				}
			}
			$if field.typ is f32 {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].f32()
					//println('set ' + field.name + ': ' + data.vals[iii])
					continue
				}
			}
		}
	}
	//println(result)
    return result
}

// Create a full featured structure from the data POST received 
// This method should be called in a annatated methode [post]
pub fn (p Product) hydrate_form_post (data map[string]string) Product {

	println("-----hydrate_form_post------")
	println(data)
    mut result := p
	for iii, name_field in data {
		$for field in Product.fields {
			// println(iii)
			// println(data[iii])
			$if field.typ is int {
				if field.name == iii {
					result.$(field.name) = data[iii].int()
					println('Set ' + field.name + ': ' + data[iii])
					continue
				}		
			}
			$if field.typ is string {
				if field.name == iii {
					result.$(field.name) = data[iii]
					println('Set ' + field.name + ': ' + data[iii])
					continue
				}
			}
			$if field.typ is bool {
				if field.name == iii {
					result.$(field.name) = data[iii].bool()
					println('Set ' + field.name + ': ' + data[iii])
					continue
				}
			}
			$if field.typ is f32 {
				if field.name == iii {
					result.$(field.name) = data[iii].f32()
					println('Set ' + field.name + ': ' + data[iii])
					continue
				}
			}
		}
	}

	schema := p.schema_lang.clone()
	today :=  time.now()
	tick := time.ticks()

	result.modified_at = tick
	if p.id == 0 {
		result.created_at = tick
	}
	println("-----result-----")
    return result
}


// [Intension]
// Concaten in one string well formated, all values set on the structure. 
// Then the string will be added used in the query to defined Value to set
// I don't know how to attach a generic to a structure
// There are some duplicate code, but no way to improve cause '$if field.typ is int' is hardcoded
// [Addendum]
// This method should be called just before a save() method
fn dehydrate_product(p Product) (string, string, string) {
	
	mut fields_to_insert :=  strings.new_builder(1024)
	mut values_to_insert := strings.new_builder(1024)
	mut values_to_update := strings.new_builder(1024)

	schema := p.schema.clone()
	println('------p.schema------')
	println(schema)

	for iii, name_field  in schema {
		match name_field {
			'id', 'created_at', 'images', 'type' { continue }
			else {
				$for field in Product.fields {
					println("test : $field.name $name_field")
					$if field.typ is int {
						if field.name == name_field {
							//println("Set: $field.name = " + p.$(field.name).str())
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' + p.$(field.name).str() + '",')
						}	
					}
					$if field.typ is string {
						if field.name == name_field {
							//println("Set: $field.name = " + p.$(field.name).str())
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' + p.$(field.name).str() + '",')
						}
					}
					$if field.typ is bool {
						if field.name == name_field {
							//println("Set: $field.name = " + p.$(field.name).str())
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' + p.$(field.name).str() + '",')
						}
					}
					$if field.typ is f32 {
						if field.name == name_field {
							//println("Set: $field.name = " + p.$(field.name).str())
							values_to_insert.write_string('\r\nprintf("%.2f", "' + p.$(field.name).str() + '"),')
							values_to_update.write_string('\r\n $name_field = printf("%.2f", "' + p.$(field.name).str() + '"),')
						}
					}
				}
				fields_to_insert.write_string('\r\n`$name_field`,')
			}
		}
	}
	//remove last comma
    fields_to_insert.go_back(1)
	values_to_insert.go_back(1)
	values_to_update.go_back(1)
    return fields_to_insert.str(), values_to_insert.str(), values_to_update.str()
}

fn dehydrate_product_lang(p Product) (string, string, string) {
	
	mut fields_to_insert :=  strings.new_builder(1024)
	mut values_to_insert := strings.new_builder(1024)
	mut values_to_update := strings.new_builder(1024)

	schema := p.schema_lang.clone()

	//println('------p.schema_lang------')
	//println(schema)

	for iii, name_field  in schema {
		match name_field {
			'id', 'images', 'type', 'tags' { continue }
			'id_product' {
				fields_to_insert.write_string('\r\n"id_product",')
				values_to_insert.write_string('\r\n"' + p.id.str() + '",')
				continue
			}
			else {
				$for field in Product.fields {
					println("test : $field.name $name_field")
					$if field.typ is int {
						if field.name == name_field {
							//println("Set: $field.name = " + p.$(field.name).str())
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' + p.$(field.name).str() + '",')
						}	
					}
					$if field.typ is string {
						if field.name == name_field {
							//println("Set: $field.name = " + p.$(field.name).str())
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' + p.$(field.name).str() + '",')
						}
					}
					$if field.typ is bool {
						if field.name == name_field {
							//println("Set: $field.name = " + p.$(field.name).str())
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' + p.$(field.name).str() + '",')
						}
					}
					$if field.typ is f32 {
						if field.name == name_field {
							//println("Set: $field.name = " + p.$(field.name).str())
							values_to_insert.write_string('\r\nprintf("%.2f", "' + p.$(field.name).str() + '"),')
							values_to_update.write_string('\r\n $name_field = printf("%.2f", "' + p.$(field.name).str() + '"),')
						}
					}
				}
				fields_to_insert.write_string('\r\n`$name_field`,')
			}
		}
	}
	//remove last comma
    fields_to_insert.go_back(1)
	values_to_insert.go_back(1)
	values_to_update.go_back(1)
    return fields_to_insert.str(), values_to_insert.str(), values_to_update.str()
}



// pub fn (mut p Product) get_images()  {
// 	//println('------------------GET IMAGE')
// 	image_ids,_ := p.db.exec( 'SELECT id_image FROM image where id == $p.id' )
// 	//mut pp := p
// 	mut ress := []Image{}
// 	mut fac := Factory{}.start().image()

// 	//println('------------------CHECK FAC')
// 	//println(fac)
// 	for id in image_ids {
// 		println('Loop id: $id')
// 		p.images << fac.filter_by_id(id.vals[0].int())
// 	}

// 	//pp.images = ress
// 	// println(ress)
// 	//return p
// }


// pub fn (mut p Product) active() {
// 	println('------------------GET active')
// 	res, code := p.db.exec( 'INSERT INTO `product` (`active`)  VALUES ();' )

// 	// println('------------------CHECK active')
// 	// println(res)
// 	p.active = 1
// 	// if code == 100 {
// 	// 	println('loop code: $code')
// 	// 	p.images << fac.filter_by_id(id.vals[0].int())
// 	// }
// }