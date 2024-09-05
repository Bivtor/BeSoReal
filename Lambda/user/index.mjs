import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

// Initialize Firebase Admin
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

export async function handler(event) {
    // Parse the incoming event (from body and headers)
    const body = JSON.parse(event.body || '{}');
    const authHeader = event.headers.Authorization || event.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return {
            statusCode: 401,
            body: JSON.stringify({ error: 'Unauthorized request: Authorization header missing or malformed' }),
        };
    }

    const idToken = authHeader.split(' ')[1]; // Extract the token

    try {
        // Verify the Firebase ID token
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        const userID = decodedToken.uid; // Extract userID from the token

        console.log('Authenticated user ID:', userID);

        // Get the username from the request body
        const { username, displayName } = body;

        if (!username) {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: 'missing username' }),
            };
        }

        if (!displayName) {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: 'missing displayName' }),
            };
        }

        // check if the username is already taken
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
        console.error('Error verifying ID token or updating document:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Error updating document' }),
        };
    }
}
