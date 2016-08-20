'use strict'

const os = require('os')
const express = require('express')
const app = express()

let ip
let port = 3000
let ifaces = os.networkInterfaces()

for ( let dev in ifaces ) {
    
    let iface = ifaces[dev].filter( details => {
        return details.family === 'IPv4' && details.internal === false
    })
    
    if ( iface.length > 0 )
        ip = iface[0].address
    
}

app.get( '/', ( req, res ) => {
    res.send( 'Hello I am app, nice to meet you.' );
})

app.listen( port, () => {
    console.log( 'App listening on', ip, 'at', port )
})