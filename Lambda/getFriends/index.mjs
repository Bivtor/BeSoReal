import { admin, db, verifyToken } from '/opt/utils.mjs';

// GET /friends

export async function handler(event) {
    try {
        const { body, decodedToken } = await verifyToken(event);
        const userID = decodedToken.uid;

        const userDoc = await db.collection('userdata').doc(userID).get();
        const userData = userDoc.data();

        var friends = [];

        for (const friendID of userData.friends) {
            const friendDoc = await db.collection('userdata').doc(friendID).get();
            const friendData = friendDoc.data();
            friends.push({
                username: friendData.username,
                displayName: friendData.displayName,
                photoURL: '',
            });
        }

        return {
            statusCode: 200,
            body: JSON.stringify({
                friends: friends,
            }),
        };
    } catch (error) {
        console.error('Error processing request:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: error.message || 'Error updating document' }),
        };
    }
}
