import * as Hapi from '@hapi/hapi'

export class VideoStreamController {
    public handleIncomingFramePayload = async (request: Hapi.Request, h: Hapi.ResponseToolkit): Promise<Hapi.ResponseObject> => {
        console.log(`Received frame payload`)
        return h.response('tada')
    }
}
