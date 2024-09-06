import { admin, db, verifyToken } from '/opt/utils.mjs';

// POST /friend

export async function handler(event) {
    try {
        const { body, decodedToken } = await verifyToken(event);
        const userID = decodedToken.uid;

        const { username } = body;

        // Get authenticated user's data
        const userDoc = await db.collection('userdata').doc(userID).get();
        const userData = userDoc.data();
        
        // Get target user's data using username
        const targetUserQuery = await db.collection('userdata').where('username', '==', username).get();
        
        if (targetUserQuery.empty) {
            return {
                statusCode: 404,
                body: JSON.stringify({ error: 'Target user not found' }),
            };
        }
        
        const targetUserID = targetUserQuery.docs[0].id;
        const targetUserDoc = db.collection('userdata').doc(targetUserID);
        
        // Prevent user from adding self as a friend
        if (userID === targetUserID) {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: 'Cannot add yourself as a friend' }),
            };
        }

        // prevent user from adding the same friend twice
        const friends = userData.friends || [];
        if (friends.includes(targetUserID)) {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: 'User is already your friend' }),
            };
        }
        
        // Check if the authenticated user has a friend request from the target user
        const friendRequests = userData.friend_requests || [];
        if (friendRequests.includes(targetUserID)) {

            // Remove target from user's friend_requests array
            await userDoc.ref.update({
                friend_requests: admin.firestore.FieldValue.arrayRemove(targetUserID)
            });
        
            // Add target to user's friends array
            await userDoc.ref.update({
                friends: admin.firestore.FieldValue.arrayUnion(targetUserID)
            });
        
            // Add user to target's friends array
            await targetUserDoc.update({
                friends: admin.firestore.FieldValue.arrayUnion(userID)
            });
        
            return {
                statusCode: 200,
                body: JSON.stringify({ message: 'Friend request accepted' }),
            };
        
        } else {
            // If no friend request from target user, send a friend request
            await targetUserDoc.update({
                friend_requests: admin.firestore.FieldValue.arrayUnion(userID)
            });
        
            return {
                statusCode: 200,
                body: JSON.stringify({ message: 'Friend request sent' }),
            };
        }

    } catch (error) {
        console.error('Error processing request:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: error.message || 'Error updating document' }),
        };
    }
}
