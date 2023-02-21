module validate
import regex


pub fn is_url(s string) bool {

 		query := r"(?P<format>https?)|(?P<format>ftps?)://[\w_.]"

    mut re := regex.regex_opt(query) or { panic(err) }
    re.debug=0
    re.group_csave_flag = true
    start, _ := re.match_string(s)

    if start >= 0 {
        return true
    } else {
        return false
    }

}

pub fn is_email(s string) bool {

 		query := r"^[a-z0-9_]+@([a-z0-9_]+\.?)+$"
    mut re := regex.regex_opt(query) or { panic(err) }
    re.debug=0
    re.group_csave_flag = true
    start, _ := re.match_string(s.to_lower())

    if start >= 0 {
        return true
    } else {
        return false
    }
}

pub fn is_name(s string) bool {

 		query := r"^[a-zA-Z_ \-\']+$"
    mut re := regex.regex_opt(query) or { panic(err) }
    
    re.group_csave_flag = true
    start, _ := re.match_string(s)

    if start >= 0 {
        return true
    } else {
        return false
    }
}

pub fn is_password_admin(s string) bool {

 		query := r"^[a-zA-Z_ \-\']+$"
    mut re := regex.regex_opt(query) or { panic(err) }
    
    re.group_csave_flag = true
    start, _ := re.match_string(s)

    if start >= 0 {
        return true
    } else {
        return false
    }
}
