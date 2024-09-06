import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
    });
}

const db = admin.firestore();

export async function verifyToken(event) {
    const body = JSON.parse(event.body || '{}');
    const authHeader = event.headers.Authorization || event.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        throw new Error('Unauthorized request: Authorization header missing or malformed');
    }

    const idToken = authHeader.split(' ')[1]; // Extract the token

    try {
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        return { body, decodedToken };
    } catch (error) {
        console.error('Error verifying ID token:', error);
        throw new Error('Error verifying ID token');
    }
}

export { admin, db };
