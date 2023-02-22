import Dashboard    from "/templates/Dashboard.js"
import Posts        from "/templates/Post.js"
import PostView     from "/templates/PostView.js"
import Settings     from "/templates/Settings.js"
import Orders       from "/templates/Order.js"

import Account      from "/backend/account.js"
import Login        from "/backend/login.js"

const pathToRegex = path => new RegExp("^" + path.replace(/\//g, "\\/").replace(/:\w+/g, "(.+)") + "$")

const getParams = match => {
    const values = match.result.slice(1)
    const keys = Array.from(match.route.path.matchAll(/:(\w+)/g)).map(result => result[1])

    return Object.fromEntries(keys.map((key, i) => {
        return [key, values[i]]
    }));
};

const navigateTo = url => {
    history.pushState(null, null, url)
    router()
};

const router = async () => {
    const routes = [
        { path: "/", view: Dashboard },
        { path: "/post", view: Posts },
        { path: "/post/:id", view: PostView },
        { path: "/settings", view: Settings },
        { path: "/order", view: Orders },
        { path: "/login", view: Login },

        { path: "/account", view: Account },
        { path: "/account/:id", view: Account }


    ];

    // Test each route for potential match
    const potentialMatches = routes.map(route => {
        return {
            route: route,
            result: location.pathname.match(pathToRegex(route.path))
        };
    });
    
    let match = potentialMatches.find(potentialMatch => potentialMatch.result !== null)

    if (!match) {
        match = {
            route: routes[0],
            result: [location.pathname]
        };
    }

    const view = new match.route.view(getParams(match))

    document.querySelector("#app").innerHTML = await view.getHtml()
};

window.addEventListener("popstate", router);

document.addEventListener("DOMContentLoaded", () => {
    document.body.addEventListener("click", e => {
        if (e.target.matches("[data-link]")) {
            e.preventDefault()
            navigateTo(e.target.href)
        }
    });

    router()
});