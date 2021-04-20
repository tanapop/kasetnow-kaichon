import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as cors from "cors";

export const UpdateChannelId = functions.https.onRequest(async (req: any, res: any) => {
    cors()(req, res, async () => {
        if (req.body.channelname && req.body.channelid && req.body.eventid) {
            const channelID = req.body.channelid
            const channelName = req.body.channelname
            const EVENTID = req.body.eventid
            await admin.firestore().collection("event")
                .doc(EVENTID).update({ channelid: channelID, channelname: channelName });
            res.status(200).json({ status: 200, message: 'อัพเดจ channel ID และ channel Name เรียบร้อย' })
        } else {
            res.status(200).json({ status: 400, message: 'คุณไม่ได้ส่งข้อมูล channelid หรือ eventid มา' })
        }
    })
});