import { admin, db, verifyToken } from '/opt/utils.mjs';

// GET /user

export async function handler(event) {
    try {
        const { body, decodedToken } = await verifyToken(event);
        const userID = decodedToken.uid;

        const userDoc = await db.collection('userdata').doc(userID).get();
        const userData = userDoc.data();

        return {
            statusCode: 200,
            body: JSON.stringify({
                username: userData.username,
                displayName: userData.displayName,
                email: decodedToken.email,
                photoURL: '',
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
