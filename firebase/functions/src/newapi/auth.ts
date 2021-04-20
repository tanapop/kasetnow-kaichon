import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as cors from "cors";

export const auth = functions.https.onRequest(async (req: any, res: any) => {
    cors()(req, res, async () => {
        var TOKEN = req.get('authorization').replace(/Bearer/gi, "").trim();
        if (TOKEN !== undefined || TOKEN !== "undefined") {
            const snapshot = await admin.firestore().collection("users").doc(TOKEN).get();
            var DATA = snapshot.data();
            var USERDATA = (DATA?.username ?? false)
            if (USERDATA) {
                res.json(DATA)
            } else {
                res.status(401).json(null)
            }
        } else {
            res.status(401).json(null)
        }
    })
});