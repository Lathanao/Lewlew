module classes
import sqlite
/* import sqlite */

[heap]
pub struct Factory {
mut:
	id    int
	title string
	text  string
	db    sqlite.DB
	cache_pragma_def map[string][]string
}

pub fn (mut f Factory) start() &Factory {
	db := sqlite.connect('/var/www/vproject/blog/db/blog.db') or { panic(err) }
	ok, code := db.exec('PRAGMA integrity_check;')
	if code == 101 {
		f.db = db 
		println('-------Assign dd-------')
	} else {
		{ panic('No connexion to database') }
	}
	println('-------Factory start-------')
	//println(f.db)
	println('-------INIT DATABASE-------')
	println(ok[0].vals[0] + ' ' + code.str() )
	println('--------------')


	res, ee :=  db.exec( 'PRAGMA database_list;' )
	// println('------------------ res.len start')
	// println(res)
	// println(ee)

	return f
}

// pub fn (mut f Factory) load_by_id(ext string, id int) Article {
// 	mut inst := classes.Article{id: id}
// 	return inst
// }
// type ArticleT = Article | []Article
// pub fn (mut f Factory) article(query map[string]string) Article {
// 	mut id := [5]
// 	if id.len == 0 {
// 		return classes.Article{id: 0}
// 	} else if id.len == 1 {
// 		return classes.Article{id: 5}
// 	} else {
// 		return classes.Article{id: 5}
// 	}
// 	return classes.Article{id: 5}
// }

// pub fn (mut f Factory) articles(query map[string]string) []Article {
// 	mut id := [5]
// 	if id.len == 0 {
// 		return [{}]
// 	} else if id.len == 1 {
// 		return [classes.Article{id: 5}]
// 	} else {
// 		return [classes.Article{id: 5}]
// 	}
// 	return [classes.Article{id: 5}]
// }

// pub fn (mut f Factory) find_all_articles() []Article {
// 	return [classes.Article{title: 'Title 1', text: 'Text 1'}, classes.Article{title: 'Title 2', text: 'Text '}]
// }

// pub fn (mut f Factory) image() Image {
// 	mut i := (Image{db: f.db}).init().save()
// 	res,_ := i.db.exec( 'pragma table_info("image");' )
// 	for line in res {
// 		i.pragma << line.vals[1]
// 		//println(line.vals[1])
// 	}
// 	return i
// }

pub fn (f Factory) product() Product {
	mut p := (Product{db: &f.db})

	// Add Generic field to easy iterate in hydrate(), etc...
	mut res,_ := p.db.exec( 'pragma table_info("product");' )
	for line in res {
		p.schema << line.vals[1]
	}
	// Add Generic Lang field to easy iterate in hydrate(), etc...
	res,_ = p.db.exec( 'pragma table_info("product_lang");' )
	for line in res {
		if line.vals[1] == 'id' { continue } // if not remove, will trouble hydrate() 
		p.schema_lang << line.vals[1]
	}
	// Add schema name to know the table base quikly
	p.schema_name = 'product'
	return p
}

// pub fn (mut f Factory) admin_user() &AdminUser {
// 	//println('---Factory---admin_user------')
// 	a := (AdminUser{AdminUserAbstract{db: &f.db}, AdminUserFilter{}, AdminUserEntity{}}).init()
// 	//println(a.db)
// 	return a
// }