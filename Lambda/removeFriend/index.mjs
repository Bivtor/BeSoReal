import { admin, db, verifyToken } from '/opt/utils.mjs';

// DELETE /friend

export async function handler(event) {
    try {
        const { body, decodedToken } = await verifyToken(event);
        const userID = decodedToken.uid;

        const { targetUserID } = body;

        // remove target from user's friends and friend_requests array
        const userDoc = await db.collection('userdata').doc(userID).get();
        await userDoc.ref.update({
            friends: admin.firestore.FieldValue.arrayRemove(targetUserID),
            friend_requests: admin.firestore.FieldValue.arrayRemove(targetUserID)
        });

        // remove user from target's friends and friend_requests array
        const targetUserDoc = await db.collection('userdata').doc(targetUserID).get();
        await targetUserDoc.ref.update({
            friends: admin.firestore.FieldValue.arrayRemove(userID),
            friend_requests: admin.firestore.FieldValue.arrayRemove(userID)
        });

    } catch (error) {
        console.error('Error processing request:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: error.message || 'Error updating document' }),
        };
    }
}
