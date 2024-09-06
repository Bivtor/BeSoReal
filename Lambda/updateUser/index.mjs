import { admin, db, verifyToken } from '/opt/utils.mjs';

// POST /updateUser

export async function handler(event) {
    try {
        const { body, decodedToken } = await verifyToken(event);
        const userID = decodedToken.uid;

        const { username, displayName } = body;

        // Check if the username is already taken
        const usernameQuerySnapshot = await db.collection('userdata')
            .where('username_lowercase', '==', username.toLowerCase())
            .where('__name__', '!=', userID) // Exclude the current user
            .get();

        if (!usernameQuerySnapshot.empty) {
            return {
                statusCode: 409, // Conflict
                body: JSON.stringify({ error: 'Username is already taken' }),
            };
        }

        // Update Firestore with the user's ID and username
        const docRef = db.collection('userdata').doc(userID);
        const dataToUpdate = {
            username: username,
            username_lowercase: username.toLowerCase(),
            displayName: displayName,
        };

        await docRef.set(dataToUpdate, { merge: true });

        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Document updated successfully!' }),
        };
    } catch (error) {
        console.error('Error processing request:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: error.message || 'Error updating document' }),
        };
    }
}
