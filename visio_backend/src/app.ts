import Server from './server'
import 'dotenv/config'

;(async () => {
    const server = new Server()
    await server.init()

    // listen on SIGINT signal and gracefully stop the server
    process.on('SIGINT', () => {
        console.log('Stopping hapi server')

        server.stop().then((err) => {
            console.log(`Server stopped`)
            process.exit(err ? 1 : 0)
        })
    })
})()
