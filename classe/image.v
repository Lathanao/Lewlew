module classes
import sqlite

struct Image {
		id    int
	pub mut:
		id_image	int
		id_product	int
		position int
		cover bool
		pragma      []string
  		db   sqlite.DB [skip]
		cache	map[string]string [skip]
}

fn (i Image) init() Image {
	println('init image')
	return i
}

// type ImageT = Image | []Image
// pub fn (mut a Article) filter(query map[string]string) ArticleT {
// 	return a.search(query)
// }

// pub fn (mut a Article) search(query map[string]string) ArticleT {
// 	for i, j in query {
// 		println(i)
// 		println(j)
// 	}
// 	return classes.Article{id: 5}
// }

pub fn (mut i Image) create() bool
{
	return true
}
	
pub fn (i Image) save() Image {
	mut res := i
	if i.id_image == 0 {
		i.db.exec(
			'INSERT INTO `image` (`id_product`, `position`, `cover`) 
			VALUES (1, 0, 2);'
			)
		res.id_image = i.db.q_int('SELECT MAX(id_image) from image')
	} else {
		i.db.exec('
		UPDATE "image" SET
		id_image = "40",
		WHERE id_image = "40";'
		)

	}
	// println('Save image: $res.id_image')
	// println('Image:')
	// println(res)
	return res
}
// pub fn (mut i Image) load(id int) bool
// {
// 	i.db.exec(
// 			'INSERT INTO `image` (`id_product`, `position`, `cover`) 
// 			VALUES (1, 0, 2);'
// 			)
// }


// pub fn (mut a App) get_last_id() int {
// 	//return App.db.exec('SELECT MAX(id_image) from image')
// }


pub fn (i Image) get_images() []Image {
	//println('------get_images---------')
	res :=  sql i.db {
		select from Image limit 10
	}
	//println(res)
	return res
}

pub fn (mut i Image) filter_by_id (q int) Image {
	//println('------IMAGE filter_by_id---------')
	res,_ :=  i.db.exec( 'select * from image where id_image == $q;' )
	//println('-------------res image')
	//println(res)
	//println('select * from image where id_image == $q;')
	if res.len == 0 {
		return Image{}
	}
	//println('------IMAGE hydrated---------')
	//println(i.hydrate(res))
	return i.hydrate(res)
}

fn (i Image) hydrate (data []sqlite.Row) Image {
    mut result := i
	for iii, name_field  in i.pragma {
		$for field in Image.fields {
			$if field.typ is int {
				if field.name == name_field {
					result.$(field.name) = data[0].vals[iii].int()
				}	
			}
			$if field.typ is string {
				if field.name == name_field {
					result.$(field.name) = data[0].vals[iii]
				}
			}
			$if field.typ is bool {
				if field.name == name_field {
					result.$(field.name) = data[0].vals[iii].bool()
				}
			}
			$if field.typ is f32 {
				if field.name == name_field {
					result.$(field.name) = data[0].vals[iii].f32()
				}
			}
		}
	}
    return result
}