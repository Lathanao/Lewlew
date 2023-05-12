module classe

import crypto.sha256
import rand
import os
import time
import sqlite
import strings

struct AdminEntity2 {
	id int
mut:
	last_name         string
	name              string
	first_name        string
	email             string
	accepts_marketing int
	addresses         int
	addresses_count   int
	default_address   int
	has_account       int
	last_order        int
	orders            int
	orders_count      int
	phone             int
	tags              int
	total_spent       int
	published_at      int
	created_at        int
	modified_at       int
}

pub fn unify_data_for_update(fields string, values string) string {
	mut values_to_update := strings.new_builder(1024)

	for iii, name_field in fields {
		values_to_update.write_string('\r\n$name_field = $values[iii],')
	}
	return values_to_update.str()
}

// Need to get the full set, like `select * from ...`
// Create a full featured structure after received data from database
// This method should be called just below a db.query(SELECT ... WHERE id = X)
fn (mut p Product) hydrate(data sqlite.Row) Product {

	mut schema := p.schema.clone()
	schema << p.schema_lang
	mut result := p
	for iii, name_field in schema {

		$for field in Product.fields {
			$if field.typ is int {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].int()
					continue
				}
			}
			$if field.typ is string {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii]
					continue
				}
			}
			$if field.typ is bool {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].bool()
					continue
				}
			}
			$if field.typ is f32 {
				if field.name == name_field {
					result.$(field.name) = data.vals[iii].f32()
					continue
				}
			}
		}
	}
	return result
}

// Create a full featured structure from the data POST received
// This method should be called in a annatated methode [post]
pub fn (p Product) hydrate_form_post(data map[string]string) Product {
	mut result := p
	for iii, name_field in data {
		$for field in Product.fields {
			$if field.typ is int {
				if field.name == iii {
					result.$(field.name) = data[iii].int()
					continue
				}
			}
			$if field.typ is string {
				if field.name == iii {
					result.$(field.name) = data[iii]
					continue
				}
			}
			$if field.typ is bool {
				if field.name == iii {
					result.$(field.name) = data[iii].bool()
					continue
				}
			}
			$if field.typ is f32 {
				if field.name == iii {
					result.$(field.name) = data[iii].f32()
					continue
				}
			}
		}
	}

	schema := p.schema_lang.clone()
	today := time.now()
	tick := time.ticks()

	result.modified_at = tick
	if p.id == 0 {
		result.created_at = tick
	}
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
	mut fields_to_insert := strings.new_builder(1024)
	mut values_to_insert := strings.new_builder(1024)
	mut values_to_update := strings.new_builder(1024)

	schema := p.schema.clone()

	for iii, name_field in schema {
		match name_field {
			'id', 'created_at', 'images', 'type' {
				continue
			}
			else {
				$for field in Product.fields {
					$if field.typ is int {
						if field.name == name_field {
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' +
								p.$(field.name).str() + '",')
						}
					}
					$if field.typ is string {
						if field.name == name_field {
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' +
								p.$(field.name).str() + '",')
						}
					}
					$if field.typ is bool {
						if field.name == name_field {
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' +
								p.$(field.name).str() + '",')
						}
					}
					$if field.typ is f32 {
						if field.name == name_field {
							values_to_insert.write_string('\r\nprintf("%.2f", "' +
								p.$(field.name).str() + '"),')
							values_to_update.write_string('\r\n $name_field = printf("%.2f", "' +
								p.$(field.name).str() + '"),')
						}
					}
				}
				fields_to_insert.write_string('\r\n`$name_field`,')
			}
		}
	}
	// remove last comma
	fields_to_insert.go_back(1)
	values_to_insert.go_back(1)
	values_to_update.go_back(1)
	return fields_to_insert.str(), values_to_insert.str(), values_to_update.str()
}

fn dehydrate_product_lang(p Product) (string, string, string) {
	mut fields_to_insert := strings.new_builder(1024)
	mut values_to_insert := strings.new_builder(1024)
	mut values_to_update := strings.new_builder(1024)

	schema := p.schema_lang.clone()

	for iii, name_field in schema {
		match name_field {
			'id', 'images', 'type', 'tags' {
				continue
			}
			'id_product' {
				fields_to_insert.write_string('\r\n"id_product",')
				values_to_insert.write_string('\r\n"' + p.id.str() + '",')
				continue
			}
			else {
				$for field in Product.fields {
					$if field.typ is int {
						if field.name == name_field {
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' +
								p.$(field.name).str() + '",')
						}
					}
					$if field.typ is string {
						if field.name == name_field {
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' +
								p.$(field.name).str() + '",')
						}
					}
					$if field.typ is bool {
						if field.name == name_field {
							values_to_insert.write_string('\r\n"' + p.$(field.name).str() + '",')
							values_to_update.write_string('\r\n $name_field = "' +
								p.$(field.name).str() + '",')
						}
					}
					$if field.typ is f32 {
						if field.name == name_field {
							values_to_insert.write_string('\r\nprintf("%.2f", "' +
								p.$(field.name).str() + '"),')
							values_to_update.write_string('\r\n $name_field = printf("%.2f", "' +
								p.$(field.name).str() + '"),')
						}
					}
				}
				fields_to_insert.write_string('\r\n`$name_field`,')
			}
		}
	}
	// remove last comma
	fields_to_insert.go_back(1)
	values_to_insert.go_back(1)
	values_to_update.go_back(1)
	return fields_to_insert.str(), values_to_insert.str(), values_to_update.str()
}

// pub fn (mut p Product) get_images()  {
// 	image_ids,_ := p.db.query( 'SELECT id_image FROM image where id == $p.id' )
// 	//mut pp := p
// 	mut ress := []Image{}
// 	mut fac := Factory{}.start().image()

// 	for id in image_ids {
// 		p.images << fac.filter_by_id(id.vals[0].int())
// 	}

// 	//pp.images = ress
// 	//return p
// }

// pub fn (mut p Product) active() {
// 	res, code := p.db.query( 'INSERT INTO `product` (`active`)  VALUES ();' )

// 	p.active = 1
// 	// if code == 100 {
// 	// 	p.images << fac.filter_by_id(id.vals[0].int())
// 	// }
// }
