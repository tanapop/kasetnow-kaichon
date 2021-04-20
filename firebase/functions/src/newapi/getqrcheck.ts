import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as cors from "cors";

export const getqrcheck = functions.https.onRequest(async (req: any, res: any) => {
    cors()(req, res, async () => {
        if (req.body.uid && req.body.qrid) {
            const UID = req.body.uid
            const QRID = req.body.qrid
            var eventData = await admin.firestore().collection("ticket")
                .doc(QRID).get();
            if (eventData.exists) {
                var DataQR = eventData.data()
                if (DataQR) {
                    if (DataQR.status) {
                        if (DataQR.userscanuid == null) {
                            await admin.firestore().collection("ticket")
                                .doc(QRID).update({
                                    userscanuid: UID,
                                    scanhit: parseInt(DataQR.scanhit) + 1
                                })
                            res.status(200).json({ status: 200, message: 'ใช้งานได้ บันทึกข้อมูลผู้ใช้งาน ตั๋วเรียบร้อย', data: DataQR })
                        } else {
                            if (UID == DataQR.userscanuid) {
                                await admin.firestore().collection("ticket")
                                    .doc(QRID).update({
                                        scanhit: parseInt(DataQR.scanhit) + 1
                                    })
                                res.status(200).json({ status: 200, message: 'ใช้งานได้', data: DataQR })
                            } else {
                                res.status(200).json({ status: 400, message: 'ตั๋วใบนี้ถูกใช้งานไปแล้ว', data: null })
                            }
                        }
                    } else {
                        res.status(200).json({ status: 400, message: 'ตั๋วใบนี้ถูกปิดการใช้งานไปแล้ว', data: null })
                    }
                } else {
                    res.status(200).json({ status: 400, message: 'ไม่พบข้อมูลตั๋ว', data: null })
                }
            } else {
                res.status(200).json({ status: 400, message: 'ไม่พบข้อมูลตั๋ว', data: null })
            }
        } else {
            res.status(200).json({ status: 400, message: 'คุณไม่ได้ส่งข้อมูล uid หรือ qrid มา', data: null })
        }
    })
});