module log

[post]
['/log']
pub fn (mut app App) log() vweb.Result {

		html := "<h1>Yo all</h1>
	
	<script>
	fetch('', {
        method: 'POST', 
        mode: 'cors',
        cache: 'no-cache', 
        credentials: 'same-origin',
        headers: {
          'Content-Type': 'application/json', 
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer', 
        body: '', 
      })
        .then((res) => res.json())
        .then((res) => (console.log(res)))
	fetch('', {
        method: 'POST', 
        mode: 'cors',
        cache: 'no-cache', 
        credentials: 'same-origin',
        headers: {
          'Content-Type': 'application/json', 
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer', 
        body: '', 
      })
        .then((res) => res.json())
        .then((res) => (console.log(res)))

	fetch('', {
        method: 'POST', 
        mode: 'cors',
        cache: 'no-cache', 
        credentials: 'same-origin',
        headers: {
          'Content-Type': 'application/json', 
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer', 
        body: '', 
      })
        .then((res) => res.json())
        .then((res) => (console.log(res)))
	</script>"

	return app.html(html)
}
