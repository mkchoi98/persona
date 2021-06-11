from firebase_admin import credentials
from firebase_admin import firestore, storage
import firebase_admin

cred = credentials.Certificate('')
firebase_admin.initialize_app(cred, {
  'projectId': '',
  'storageBucket': ''
})

db = firestore.client()
