import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as cors from "cors";

export const checkuser = functions.https.onRequest(async (req: any, res: any) => {
    cors()(req, res, async () => {
        if (req.body.username && req.body.password) {
            const USERNAME = req.body.username
            const PASSWORD = req.body.password
            const snapshot = await admin.firestore().collection("users")
                .where("username", "==", USERNAME).limit(1).get();
            if (snapshot.empty) {
                res.status(200).json({ status: 400, message: 'ไม่พบ User', token: null })
            } else {
                snapshot.forEach((doc: any) => {
                    res.json({ status: 200, message: 'Success', token: doc.id })
                });
            }
        } else {
            res.status(200).json({ status: 400, message: 'กรอกข้อมูลไม่ครบ', token: null })
        }
    })
});