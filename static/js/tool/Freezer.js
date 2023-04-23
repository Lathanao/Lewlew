/* Welcome to freezer.js playground, feel free to clone it
 * Docs are available at https://github.com/arqex/freezer
 * Enjoy
 * http://jsbin.com/fedeva/4/edit?js,console,output
 */

var store = new Freezer({
  a: { x: 1, y: 2, z: [0, 1, 2] },
  b: [5, 6, 7, { m: 1, n: 2 }],
  c: 'Hola',
  d: null, // It is possible to store whatever
})

store.on('update', function (update) {
  console.log('I was updated: ' + update.a.z[3])
})

var data = store.get()
var updated = data.a.z.push(100)

console.log('You get the updated node? ' + (updated === store.get().a.z))
console.log('The whole tree has changed? ' + (data !== store.get()))
console.log('Other nodes are reused? ' + (data.b === store.get().b))
