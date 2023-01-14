import * as Hapi from '@hapi/hapi'
import { VideoStreamController } from './controllers/videoStreamController'

export default class Router {
    constructor(private hapiServer: Hapi.Server) {}

    public async init(): Promise<void> {
        console.log('Router - Start adding routes')

        this.hapiServer.route({
            method: 'GET',
            path: '/',
            options: {
                auth: false,
                handler: (request: Hapi.Request, response) => {
                    console.log(`Request received! Query: ${JSON.stringify(request.query)}`)
                    return response.response({ success: true })
                },
                description: 'GET request health check',
            },
        })

        this.hapiServer.route({
            method: 'POST',
            path: '/',
            options: {
                auth: false,
                handler: (request: Hapi.Request, response) => {
                    console.log(`Request received! Payload: ${JSON.stringify(request.payload)}`)
                    return response.response({ success: true })
                },
                description: 'POST request health check',
            },
        })

        const videoStreamController = new VideoStreamController()
        this.hapiServer.route({
            method: 'POST',
            path: '/videoStream/uploadFramePayload',
            options: {
                auth: false,
                handler: videoStreamController.handleIncomingFramePayload,
                description: 'upload and process an incoming frame payload',
            },
        })

        console.log('Router - Finish adding routes')
    }
}
