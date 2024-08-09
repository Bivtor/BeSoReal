import { initializeApp } from "firebase/app";
// import { getAnalytics } from "firebase/analytics";
import { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword } from "firebase/auth";
import { addDoc, collection } from "firebase/firestore";
import "dotenv/config";
// Not sure how to decipher your flutter code yet so I'm just going to add some db access code

// Import the functions you need from the SDKs you need
const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: "besoreal-f5fd5.firebaseapp.com",
  projectId: "besoreal-f5fd5",
  storageBucket: "besoreal-f5fd5.appspot.com",
  messagingSenderId: "697261533137",
  appId: "1:697261533137:web:1124c053e47a73c2ec62f0",
  measurementId: "G-XRNV81R5YX",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
// const analytics = getAnalytics(app);

const auth = getAuth();
const email = "exmaple@ucla.edu";
const password = "fuckyou22";

// Create a firestore entry associated with the uid
const createUserEntry = (uid) => {
  addDoc(collection(firestore, "userdata"), {
    uid: uid,
  });
};

const create = () => {
  createUserWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      // Signed up
      const user = userCredential.user;
      // Create firestore entry using uid
      createUserEntry(user.uid);
      // ...
    })
    .catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
      // ..
    });
};

const getUser = () => {
  signInWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      // Signed in
      const user = userCredential.user;
      userCredential.user.uid;

      // ...
    })
    .catch((error) => {
      const errorCode = error.code;
      const errorMessage = error.message;
    });
};

getUser();
