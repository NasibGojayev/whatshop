const admin = require("firebase-admin");
const fs = require("fs");

// Initialize Firebase Admin
const serviceAccount = require("./serviceAccountKey.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function exportData() {
  const collections = await db.listCollections();
  let data = {};

  for (let collection of collections) {
    const snapshot = await collection.get();
    data[collection.id] = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));
  }

  fs.writeFileSync("firestore-export.json", JSON.stringify(data, null, 2));
  console.log("Firestore data exported successfully!");
}

exportData();
