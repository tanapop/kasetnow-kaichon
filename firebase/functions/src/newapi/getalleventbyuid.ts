import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as cors from "cors";

function formatDate(date: string | number | Date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2)
        month = '0' + month;
    if (day.length < 2)
        day = '0' + day;

    return [year, month, day].join('-');
}

export const getallevent = functions.https.onRequest(async (req: any, res: any) => {
    cors()(req, res, async () => {
        const snapshot = await admin.firestore().collection("event")
            .where("date", ">=", formatDate(new Date()))
            .orderBy("date", "asc").get()
        if (snapshot.empty) {
            res.json({ status: 400, message: 'ยังไม่มีกิจกรรม', data: [] })
        } else {
            var datarest: any[] = []
            datarest = await new Promise((rest) => {
                var dataarr: any[] = []
                var index = 0
                snapshot.forEach((doc: any) => {
                    var data = doc.data()
                    if (data.publisher) {
                        // if (!data.freeorprice) {
                            dataarr.push(doc.data())
                        // }
                    }
                    index++
                    if (index == snapshot.size) {
                        rest(dataarr)
                    }
                });
            })
            if (datarest.length == 0) {
                res.json({ status: 400, message: 'ยังไม่มีกิจกรรม', data: [] })
            } else {
                res.json({ status: 200, message: 'กิจกรรมทั้งหมดที่มี', data: datarest })
            }
        }
    })
});