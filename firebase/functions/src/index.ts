import * as functions from 'firebase-functions';
import * as admin from "firebase-admin";

admin.initializeApp();

exports.chatNotification = functions.https.onCall(async (data, context) => {
    console.log("-------------------- START");
	const toUserID = data.toUserID;
	const fromUserEmail = data.fromUserEmail;
	const chatID = data.chatID;
	
	const toUserRef = admin.firestore().collection("users").doc(toUserID);
	const payload = {
		notification: {
			title: "Hey!",
			body: fromUserEmail + " sent you a message.",
		},
		data: {
			"tag": "chat",
			"chatID": chatID,
		},
	};
	
	const doc: FirebaseFirestore.DocumentData | undefined = (await toUserRef.collection('tokens').doc('fcm').get()).data();	
    let didSend = false;
    
	if (doc) {
        const tokens = doc.tokens;
        const response = await admin.messaging().sendToDevice(tokens, payload);    
        response.results.forEach(async (result, index) => {
            if (result.error) {
                console.error(
                    "-------------------- Failure sending notification to " + toUserID + " with token: ",
                    tokens[index],
                    result.error
                );
                
                if (
                    result.error.code === "messaging/invalid-registration-token" ||
                    result.error.code === "messaging/registration-token-not-registered"
                ) {
                    await toUserRef.update({
                        settings: {
                            tokens: {
                                fcm: admin.firestore.FieldValue.arrayRemove(tokens[index]),
                            },
                        },
                    });
                }
                didSend = false;
            } else {
                console.log("-------------------- SUCESSFULLY SENT USER " + toUserID + " AN ALERT");
                didSend = true;
            }
        });
	}
	
    console.log("-------------------- END");
	return {
        'didComplete': didSend,
    };
});