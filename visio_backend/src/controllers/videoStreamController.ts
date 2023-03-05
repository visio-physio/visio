import * as Hapi from '@hapi/hapi'
import moment from 'moment'

interface FramePayload {
    key: string
}

let TEMP_PREVIOUS_REQUEST_AT = moment()

export class VideoStreamController {
    public handleIncomingFramePayload = async (request: Hapi.Request, h: Hapi.ResponseToolkit): Promise<Hapi.ResponseObject> => {
        const currTime = moment()
        console.log(`Received frame payload, time since last request: ${currTime.diff(TEMP_PREVIOUS_REQUEST_AT)}`)
        TEMP_PREVIOUS_REQUEST_AT = currTime

        const payload = request.payload as FramePayload
        return h.response('tada')
    }
}
