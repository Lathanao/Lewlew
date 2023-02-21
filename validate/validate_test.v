module main
import regex


fn  main() {

		println("======== is_email true ==========")
		println(validate.is_email("Tanguy@gmail.com"))
 		println(validate.is_email("tanguy@gmail.com"))
		println(validate.is_email("tanguy.salmon.yo@gmail.com"))
		println(validate.is_email("tanguy.salmon-yo@gmail.com"))
		println(validate.is_email("123456789.tanguy@gmail.com"))
		println(validate.is_email("tanguy@gm-ail.com"))
		println(validate.is_email("tanguy@gmail.com$"))

		println("======== is_email false ==========")
		println(validate.is_email("tanguy@@gmail.com"))
		println(validate.is_email("tanguy.salmon:yo@gmail.com"))
		println(validate.is_email("@gmail.com"))
		println(validate.is_email("tanguy@gmail"))
		println(validate.is_email("tanguy@gmail.com&<script>"))
		println(validate.is_email("tanguy@gmail.com<script>"))
		println(validate.is_email("<script>tanguy@gmail.com"))
		println(validate.is_email("<script>%tanguy@gmail.com"))
		println(validate.is_email("/<tanguy@gmail.com"))
		println(validate.is_email("tanguy@gmail.com/<"))
		println(validate.is_email("tanguy@gmail.com.com"))
		println(validate.is_email("tanguy@gmail.com$"))
		println(validate.is_email("tanguy@gmail.com$"))
		
		println("========= is_url true =========")
		println(validate.is_url("https://www.youtube.com/watch?v=F-Y5T3-lyyc"))
		println(validate.is_url("http://www.youtube.com/watch?v=F-Y5T3-lyyc"))
		println(validate.is_url("htts://www.youtube.com/watch?v=F-Y5T3-lyyc"))
		println(validate.is_url("https://www.youtube.com/watch?v=F-Y5T3-lyyc"))
		println(validate.is_url("https://www.Youtube"))

		println("========= is_url false =========")
		println(validate.is_url("https://www"))
		println(validate.is_url("http://www"))
		println(validate.is_url("https://www.Youtube"))

		println("========= is_name true =========")
		println(validate.is_name("https://www.Youtube"))
		println(validate.is_name("tanguy"))
		println(validate.is_name("Tanguy Salmon"))
		println(validate.is_name("Tanguy-SALMON"))
		println(validate.is_name("tanguy l'ar"))

		println("========== is_name false ========")
		println(validate.is_name("tanguy l'ar}"))
		println(validate.is_name("tanguy l'ar7"))
		println(validate.is_name("tanguy l'ar~%"))
		println(validate.is_name("acc +13 pippo"))
}