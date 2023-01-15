import * as Hapi from '@hapi/hapi'
import Router from './router'

export default class Server {
    private readonly hapiServer: Hapi.Server

    constructor() {
        this.hapiServer = new Hapi.Server({
            port: process.env.PORT,
        })
    }

    public async init(): Promise<void> {
        try {
            await this.hapiServer.start()

            const router = new Router(this.hapiServer)
            await router.init()

            console.log(`Server - Up and running at ${this.hapiServer.info.uri}`)
        } catch (error) {
            console.log(`Server - There was something wrong: ${error}`)
        }
    }

    public async stop(): Promise<Error | void> {
        console.log(`Server - Stopping execution`)
        return await this.hapiServer.stop()
    }
}
