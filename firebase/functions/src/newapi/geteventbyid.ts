import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as cors from "cors";

export const geteventbyid = functions.https.onRequest(async (req: any, res: any) => {
    cors()(req, res, async () => {
        if (req.body.eventid) {
            const EVENTID = req.body.eventid
            var eventData = await admin.firestore().collection("event")
                .doc(EVENTID).get();
            if (eventData.exists) {
                res.status(200).json({ status: 200, message: 'ข้อมูล EventID ' + EVENTID, data: eventData.data() })
            } else {
                res.status(200).json({ status: 400, message: 'ไม่พบ EventID นี้ ' + EVENTID, data: null })
            }
        } else {
            res.status(200).json({ status: 400, message: 'คุณไม่ได้ส่งข้อมูล liveid หรือ eventid มา', data: null })
        }
    })
});