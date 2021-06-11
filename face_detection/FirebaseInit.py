from firebase_admin import credentials
from firebase_admin import firestore, storage
import firebase_admin

cred = credentials.Certificate('persona-d1ed9-firebase-adminsdk-pyf6e-951437f2bf.json')
firebase_admin.initialize_app(cred, {
  'projectId': 'persona-d1ed9',
  'storageBucket': 'persona-d1ed9.appspot.com'
})

db = firestore.client()